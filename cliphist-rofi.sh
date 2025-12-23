#!/usr/bin/env bash

dir="$HOME/.config/rofi/launchers/type-1"
theme='style-6'

cliphist list | rofi -dmenu -theme ${dir}/${theme}.rasi | cliphist decode | wl-copy
dunstify -t 3000 -i /usr/share/icons/Tela-circle-nord/24/panel/clipit-trayicon.svg "Selection copied" "$(wl-paste)"
