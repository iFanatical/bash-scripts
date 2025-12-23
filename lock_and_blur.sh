#!/usr/bin/env bash

# set the icon and a temporary location for the screenshot to be stored
icon="$HOME/source-files/white_lock.png"
tmpbg='/tmp/screen.png'

# take a screenshot
scrot "$tmpbg"

# blur the screenshot by resizing and scaling back up
magick "$tmpbg" -filter Gaussian -thumbnail 20% -sample 500% "$tmpbg"

# overlay the icon onto the screenshot
magick "$tmpbg" "$icon" -gravity center -composite "$tmpbg"

# lock the screen with the blurred screenshot
i3lock -i "$tmpbg"
