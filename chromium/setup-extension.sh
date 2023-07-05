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
curl -o /usr/share/bookmark-bridge.crx -L https://github.com/huronOS/bookmark-bridge/releases/latest/download/bookmark-bridge.crx

# The extension loader
CHROMIUM_EXT_LOADER_PATH="/usr/share/chromium/extensions"
mkdir -p $CHROMIUM_EXT_LOADER_PATH
cp chrome-extension-loader.json "$CHROMIUM_EXT_LOADER_PATH/cbfajpicdmpnnoijdmhdomaailmdaiim.json"

# The extension's native host
CHROMIUM_NATIVE_HOST="/etc/chromium/native-messaging-hosts"
mkdir -p $CHROMIUM_NATIVE_HOST
cp chrome-native-host.json "$CHROMIUM_NATIVE_HOST/bookmarks_fetcher.json"

# The middleman between huron and the browser
cp ../app/bookmarks-fetcher.py /usr/bin/bookmarks-fetcher.py
cp ../app/current-bookmarks /usr/share/current-bookmarks
chmod 744 /usr/bin/bookmarks-fetcher.py
chown contestant /usr/bin/bookmarks-fetcher.py