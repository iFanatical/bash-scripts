#!/usr/bin/env bash

if ls /sys/class/power_supply/BAT* &>/dev/null; then
    echo "Laptop detected — configuring eDP-1..."
    xrandr --output eDP-1 --primary
 
    echo "Done."
else
    echo "Desktop detected — configuring DisplayPort-0 and DisplayPort-1..."
    echo "Configuring monitor defaults..."

    xrandr --output DisplayPort-0 --mode 1920x1080 --rate 100.00 --left-of DisplayPort-1 \
           --output DisplayPort-1 --mode 1920x1080 --rate 100.00 --primary

    xrandr --output DisplayPort-1 --primary
 
    echo "Done."
fi
