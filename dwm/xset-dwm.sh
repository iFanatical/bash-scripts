#!/usr/bin/env bash

cpu(){
    read cpu a b c previdle rest < /proc/stat
    prevtotal=$((a+b+c+previdle))
    sleep 0.5
    read cpu a b c idle rest < /proc/stat
    total=$((a+b+c+idle))
    cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
    echo -e " $cpu%"
}

mem(){
    usedmem=$(free | awk '/^Mem/ {print $3}')
    totalmem=$(free | awk '/^Mem/ {print $2}')

    percent=$(echo "($usedmem * 100) / $totalmem" | bc)

    echo -e " ${percent}%"

}

gpu(){
    USAGE="$(cat /sys/class/drm/card1/device/gpu_busy_percent)"
    echo -e " ${USAGE}%"
}

kernel(){
    kernel="uname -r"
    echo -e "󰌽 $(kernel)"
}

dte(){
    dte="$(date '+%b %d (%a) %I:%M%p')"
    echo -e "󱑁 $dte"
}

while true; do
    xsetroot -name "$(cpu) | $(mem) | $(gpu) | $(dte)"
    sleep 5s
done &
