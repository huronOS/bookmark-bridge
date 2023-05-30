#!/bin/bash

apt install python-is-python3

echo "Preparing native app"
cp app/* /usr/bin

echo "Preparing firefox"
FF_NATIVE_HOST="/usr/lib/mozilla/native-messaging-hosts"
mkdir -p $FF_NATIVE_HOST
cp ff_bookmarks_fetcher.json "$FF_NATIVE_HOST/bookmarks_fetcher.json"

FF_EXT_PATH="/usr/lib/firefox-esr/distribution/extensions"
mkdir -p $FF_EXT_PATH
cp built-files/bookmarks.xpi "$FF_EXT_PATH/bookmarks@huronos.org.xpi"

rm /usr/lib/firefox-esr/firefox.cfg

mv firefox.txt /usr/lib/firefox-esr/firefox.cfg


echo "Preparing chrome & chromium extension"
EXT_PATH="/usr/share"
mkdir -p $EXT_PATH
cp built-files/bookmarks.crx "$EXT_PATH/bookmarks.crx"

echo "Preparing chrome"
CHROME_NATIVE_HOST="/etc/opt/chrome/native-messaging-hosts"
mkdir -p $CHROME_NATIVE_HOST
cp chrome_bookmarks_fetcher.json "$CHROME_NATIVE_HOST/bookmarks_fetcher.json"

CHROME_EXT_PATH="/opt/google/chrome/extensions"
mkdir -p $CHROME_EXT_PATH
EXT_ID="cbfajpicdmpnnoijdmhdomaailmdaiim"
cp  "$EXT_ID.json" "$CHROME_EXT_PATH/$EXT_ID.json"

echo "Preparing chromium"
CHROMIUM_NATIVE_HOST="/etc/chromium/native-messaging-hosts"
mkdir -p $CHROMIUM_NATIVE_HOST
cp chrome_bookmarks_fetcher.json "$CHROMIUM_NATIVE_HOST/bookmarks_fetcher.json"

# For some reason chromium complaints that it doesn't find the manifest, but still loads the extension
CHROMIUM_EXT_PATH="/usr/share/chromium/extensions"
mkdir -p $CHROMIUM_EXT_PATH
EXT_ID="cbfajpicdmpnnoijdmhdomaailmdaiim"
cp  "$EXT_ID.json" "$CHROMIUM_EXT_PATH/$EXT_ID.json"

echo "Done(?)"