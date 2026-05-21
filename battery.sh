#!/usr/bin/env bash

BAT_PATH=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1)
source "$SCRIPTS/bar-colors.sh"

# no battery — desktop machine, output nothing
[ -z "$BAT_PATH" ] && exit 0

BAT_CAP=$(cat "$BAT_PATH/capacity" 2>/dev/null)
BAT_STATUS=$(cat "$BAT_PATH/status" 2>/dev/null)

if [ "$BAT_STATUS" = "Charging" ]; then
    BAT_ICON="$(bar_color '#9ece6a' '󰂅')"
elif [ "$BAT_CAP" -le 5 ]; then
    BAT_ICON="$(bar_color '#f7768e' '󰁺')"
elif [ "$BAT_CAP" -le 20 ]; then
    BAT_ICON="$(bar_color '#f7768e' '󰁻')"
elif [ "$BAT_CAP" -le 40 ]; then
    BAT_ICON="$(bar_color '#e0af68' '󰁽')"
elif [ "$BAT_CAP" -le 60 ]; then
    BAT_ICON="$(bar_color '#e0af68' '󰁿')"
elif [ "$BAT_CAP" -le 80 ]; then
    BAT_ICON="$(bar_color '#0db9d7' '󰂁')"
elif [ "$BAT_CAP" -le 100 ]; then
    BAT_ICON="$(bar_color '#0db9d7' '󰁹')"
fi

echo "$BAT_ICON $BAT_CAP%"
