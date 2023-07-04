#!/usr/bin/env python
import sys
import json
import struct
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

FILE_PATH = "/usr/share"
FILE_NAME = "current-bookmarks"


class FileModifiedHandler(FileSystemEventHandler):

    def __init__(self, path, file_name, callback):
        self.observer = None
        self.file_name = file_name
        self.callback = callback
        self.path = path

    # Using on_closed because it happens after writing
    # and when writing, the on_modified is triggered twice
    def on_closed(self, event):
        # Filter out changes in the directory / other files in the directory
        #  so we only track the file we're interested
        if event.is_directory or not event.src_path.endswith(self.file_name):
            return
        self.callback()

    def start_observer(self):
        # set observer to watch for changes in the directory
        self.observer = Observer()
        self.observer.schedule(self, self.path, recursive=False)
        self.observer.start()
        self.observer.join()


def get_data():
    # Open the file in read mode
    file = open(f'{FILE_PATH}/{FILE_NAME}', 'r')
    # The bookmarks should be the first and only line
    # it is required to remove anything that is not a character at the end
    # so it doesn't make a mess on the extension side
    bookmarks = file.readline().strip()
    return bookmarks


# Encode a message for transmission given its content.
def encodeMessage(messageContent):
    # https://docs.python.org/3/library/json.html#basic-usage
    # To get the most compact JSON representation, you should specify
    # (',', ':') to eliminate whitespace.
    # We want the most compact representation because the browser rejects
    # messages that exceed 1 MB.
    encodedContent = json.dumps(messageContent, separators=(',', ':')).encode('utf-8')
    encodedLength = struct.pack('@I', len(encodedContent))
    return {'length': encodedLength, 'content': encodedContent}


def send_bookmarks():
    encodedMessage = encodeMessage(get_data())
    sys.stdout.buffer.write(encodedMessage['length'])
    sys.stdout.buffer.write(encodedMessage['content'])
    sys.stdout.buffer.flush()


send_bookmarks()
file_watcher = FileModifiedHandler(FILE_PATH, FILE_NAME, send_bookmarks)
try:
    file_watcher.start_observer()
except KeyboardInterrupt:
    file_watcher.observer.stop()
