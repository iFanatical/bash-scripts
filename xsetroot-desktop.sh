#!/usr/bin/env bash
KERNEL=$(uname -r)
KBD=$(echo -e "$(setxkbmap -query | awk '/layout/ {print $2}')")

while true; do
    if ! xset q >/dev/null 2>&1; then
        echo "X display no longer available. Exiting status script." >&2
        exit 1
    fi
    VOL=$(pamixer --get-volume-human 2>/dev/null)
    CPU=$(top -bn1 | awk '/^%Cpu/ {printf "%.0f%%", $2 + $4}')
    TIME=$(date +"%H:%M:%S")
    MEM=$(free -h --giga | awk '/^Mem:/ {print $3"/"$2}')
    xsetroot -name "  $KBD |  $KERNEL |  $CPU |  $MEM |  $VOL | 󰸗 $TIME "
    
    sleep 1
done
