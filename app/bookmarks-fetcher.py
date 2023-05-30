#!/usr/bin/env python

import sys
import json
import struct
import subprocess
import time

def get_data():
    result = subprocess.run(['/usr/bin/current-bookmarks'], capture_output=True, text=True).stdout.strip()
    return result

# Encode a message for transmission,
# given its content.
def encodeMessage(messageContent):
    # https://docs.python.org/3/library/json.html#basic-usage
    # To get the most compact JSON representation, you should specify 
    # (',', ':') to eliminate whitespace.
    # We want the most compact representation because the browser rejects
    # messages that exceed 1 MB.
    encodedContent = json.dumps(messageContent, separators=(',', ':')).encode('utf-8')
    encodedLength = struct.pack('@I', len(encodedContent))
    return {'length': encodedLength, 'content': encodedContent}

    # Send an encoded message to stdout
def sendMessage(encodedMessage):
    sys.stdout.buffer.write(encodedMessage['length'])
    sys.stdout.buffer.write(encodedMessage['content'])
    sys.stdout.buffer.flush()

while True:
    # receivedMessage = getMessage()
    # if receivedMessage == "ping":
    sendMessage(encodeMessage(get_data()))
    time.sleep(60)