# Preparing everything
Execute `prepare.sh` and you'll have all set

To update the bookmarks use `sudo sed -i 's@^BOOKMARKS.*"@BOOKMARKS="'"${BOOKMARKS}"'"@' /usr/bin/`

# Building chromium extension
To build the chromium extension is through the Pack extension option in the Extension options

# Building firefox extension
To build the firefox extension is enough with compressing the bookmark-bridge folder into an xpi file
```
cd bookmark-bridge && 7z a ../bookmark-bridge.xpi * -r
```

# Notes
This extension requires `python-is-python3` to work properly

# Relevant paths
FF_NATIVE_HOST="/usr/lib/mozilla/native-messaging-hosts"
FF_EXT_PATH="/usr/lib/firefox-esr/distribution/extensions"
CHROME_NATIVE_HOST="/etc/opt/chrome/native-messaging-hosts"
CHROME_EXT_PATH="/opt/google/chrome/extensions"
CHROMIUM_NATIVE_HOST="/etc/chromium/native-messaging-hosts"
CHROMIUM_EXT_PATH="/usr/share/chromium/extensions"
