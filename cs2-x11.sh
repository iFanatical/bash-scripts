#!/usr/bin/env bash

xrandr --output DisplayPort-1 --mode "1280x960_100.00"
#xrandr --output DisplayPort-1 --mode "1440x1080_100"
sleep 5
steam -applaunch 730
sleep 10
while pgrep -x "cs2" > /dev/null; do
    sleep 5
done

xrandr --output DisplayPort-1 --mode "1920x1080" --rate 100
