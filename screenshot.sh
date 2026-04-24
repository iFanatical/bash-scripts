#!/usr/bin/env bash
FILENAME="$(date +'%Y-%m-%d-%H%M%S_screenshotcmd.png')"
SAVEDIR=${XDG_PICTURES_DIR}/screenshots
SAVE_FULLPATH="$SAVEDIR/$FILENAME"

# run screenshot command — bail out if maim fails or produces no output
if ! maim -s > /tmp/screenshot_$$.png || [ ! -s /tmp/screenshot_$$.png ]; then
    rm -f /tmp/screenshot_$$.png
    exit 0
fi

# copy to clipboard and save to disk
xclip -selection clipboard -t image/png < /tmp/screenshot_$$.png
mv /tmp/screenshot_$$.png "$SAVE_FULLPATH"

# send notification that copy occurred
dunstify -t 4000 -i "$SAVE_FULLPATH" "Screenshot saved: $FILENAME"
