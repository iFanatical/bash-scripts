#!/bin/bash

FILENAME="$(date +'%Y-%m-%d-%H%M%S_screenshotcmd.png')"
SAVEDIR=${XDG_PICTURES_DIR}
SAVE_FULLPATH="$SAVEDIR/$FILENAME"

# run screenshot command
maim -s | xclip -selection clipboard -t image/png

# copy to clipboard
xclip -selection clipboard -o > $SAVE_FULLPATH

# send notification that copy occurred
dunstify -t 4000 -i $SAVE_FULLPATH "Screenshot saved: $FILENAME"
