#!/usr/bin/env bash

dir="$HOME/.config/rofi/launchers/type-1"
theme='style-6-cliphist'

# Start greenclip daemon if it isn't already running
if ! pgrep -x greenclip > /dev/null; then
    greenclip daemon &
    disown
    sleep 0.2
fi

# Show history in rofi with image thumbnails
CHOICE=$(greenclip print | rofi \
    -dmenu \
    -i \
    -show-icons \
    -theme ${dir}/${theme} \
    -p "clipboard" \
    -theme-str 'element-icon { size: 3em; }' \
    -theme-str 'listview { lines: 10; }')

# Cancelled
[ -z "$CHOICE" ] && exit 0

# Put the selection back on the clipboard.
# greenclip print <arg> re-copies the matching entry (handles images correctly).
echo -n "$CHOICE" | greenclip print
