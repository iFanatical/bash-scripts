#!/usr/bin/env bash

dir="$HOME/.config/rofi/launchers/type-1/"
theme="youtube-vlc-style-6.rasi"

URL=$(echo "" | rofi -dmenu -theme ${dir}/${theme})
[ -z "$URL" ] && exit 1
/usr/bin/vlc --started-from-file %U "$(yt-dlp -f best -g "$URL")"
