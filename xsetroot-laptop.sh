#!/usr/bin/env bash
KERNEL=$(uname -r)
KBD=$(setxkbmap -query | awk '/layout/ {print $2}')

while true; do
    if ! xset q >/dev/null 2>&1; then
        exit 1
    fi

    TIME=$(date +"%H:%M:%S")
    MEM=$(free -h --giga | awk '/^Mem:/ {print $3"/"$2}')

    # battery
    BAT_PATH=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1)
    BAT_CAP=$(cat "$BAT_PATH/capacity" 2>/dev/null)
    BAT_STATUS=$(cat "$BAT_PATH/status" 2>/dev/null)
    if [ "$BAT_STATUS" = "Charging" ]; then
        BAT_ICON="󰂅"
    elif [ "$BAT_CAP" -le 10 ]; then
        BAT_ICON="󰁺"
    elif [ "$BAT_CAP" -le 25 ]; then
        BAT_ICON="󰁻"
    elif [ "$BAT_CAP" -le 50 ]; then
        BAT_ICON="󰁾"
    elif [ "$BAT_CAP" -le 75 ]; then
        BAT_ICON="󰂀"
    else
        BAT_ICON="󰁹"
    fi

    xsetroot -name "  $KBD |  $KERNEL |  $MEM | $BAT_ICON $BAT_CAP% | 󰸗 $TIME "

    sleep 1
done
