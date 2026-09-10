#!/usr/bin/env bash

if ls /sys/class/power_supply/BAT* &>/dev/null; then
    # ── LAPTOP ──────────────────────────────────────────────────────────────
    echo "Laptop detected — configuring eDP-1..."
    echo "Applying saturation..."
    vibrant-cli eDP-1 1.5
    xrandr --output eDP-1 --primary
 
    echo "Done."
else
    # ── DESKTOP ─────────────────────────────────────────────────────────────
    echo "Desktop detected — configuring DisplayPort-0 and DisplayPort-1..."
    echo "Adding new modelines..."
    xrandr --newmode "1280x960_100.00"  162.00  1280 1376 1512 1620  960  963  967 1000 -hsync -vsync
    xrandr --addmode DisplayPort-1 "1280x960_100.00"
 
    xrandr --newmode "1440x1080_100"    226.97  1440 1552 1712 1984  1080 1081 1084 1144 -hsync -vsync
    xrandr --addmode DisplayPort-1 "1440x1080_100"
 
    xrandr --newmode "1400x1050_100"    214.39  1400 1512 1664 1928  1050 1051 1054 1112 -hsync -vsync
    xrandr --addmode DisplayPort-1 "1400x1050_100"
    echo "Configuring monitor defaults..."
    xrandr --output DisplayPort-0 --mode 1920x1080 --rate 100.00 --left-of DisplayPort-1 \
           --output DisplayPort-1 --mode 1920x1080 --rate 100.00 --primary
    echo "Applying saturation..."
    vibrant-cli DisplayPort-1 1.5
    vibrant-cli DisplayPort-0 1.5
 
    xrandr --output DisplayPort-1 --primary
 
    echo "Done."
fi
