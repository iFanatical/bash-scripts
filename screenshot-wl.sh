#!/usr/bin/env bash

FILENAME="$(date +'%Y-%m-%d-%H%M%S_screenshotcmd.png')"
SAVEDIR=${XDG_PICTURES_DIR}/screenshots
SAVE_FULLPATH="$SAVEDIR/$FILENAME"

# run screenshot command
grim -g "$(slurp)" | wl-copy

# copy to clipboard
wl-paste > $SAVE_FULLPATH

# send notification that copy occurred
dunstify -t 4000 -i $SAVE_FULLPATH "Screenshot saved: $FILENAME"
