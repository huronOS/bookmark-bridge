#!/bin/bash

#	setup-extension.sh
#	Script to prepare the bookmark-bridge extension in chromium
#
#	Copyright (C) 2022, huronOS Project:
#		<http://huronos.org>
#
#	Licensed under the GNU GPL Version 2
#		<http://www.gnu.org/licenses/gpl-2.0.html>
#
#	Authors:
#		Daniel Cerna <dcerna@huronos.org>

# Use this path as the working directory
cd "$(dirname "$0")" || exit

## Prepare bookmarks extension
# The extension
FF_EXT_PATH="/usr/lib/firefox-esr/distribution/extensions"
mkdir -p $FF_EXT_PATH
curl -o "$FF_EXT_PATH/bookmarks@huronos.org.xpi" -L https://github.com/huronOS/bookmark-bridge/releases/latest/download/bookmark-bridge.xpi

# The extension's native host
FF_NATIVE_HOST="/usr/lib/mozilla/native-messaging-hosts"
mkdir -p $FF_NATIVE_HOST
cp firefox-native-host.json "$FF_NATIVE_HOST/bookmarks_fetcher.json"

# The middleman between huron and the browser
cp ../app/bookmarks-fetcher.py /usr/bin/bookmarks-fetcher.py
cp ../app/current-bookmarks /usr/share/current-bookmarks
chmod 744 /usr/bin/bookmarks-fetcher.py
chown contestant /usr/bin/bookmarks-fetcher.py