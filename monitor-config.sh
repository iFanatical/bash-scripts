#!/usr/bin/env bash

if ls /sys/class/power_supply/BAT* &>/dev/null; then
    # ── LAPTOP ──────────────────────────────────────────────────────────────
    echo "Laptop detected — configuring eDP-1..."
    echo "Applying saturation..."
    "$HOME/.custom-exes/cmdemo-app/cmdemo_script" eDP-1 1.2
    xrandr --output eDP-1 --primary
 
    echo "Done."
else
    # ── DESKTOP ─────────────────────────────────────────────────────────────
    echo "Desktop detected — configuring DP-1 and DP-2..."
    echo "Adding new modelines..."
    xrandr --newmode "1280x960_100.00"  162.00  1280 1376 1512 1620  960  963  967 1000 -hsync -vsync
    xrandr --addmode DP-2 "1280x960_100.00"
 
    xrandr --newmode "1440x1080_100"    226.97  1440 1552 1712 1984  1080 1081 1084 1144 -hsync -vsync
    xrandr --addmode DP-2 "1440x1080_100"
 
    xrandr --newmode "1400x1050_100"    214.39  1400 1512 1664 1928  1050 1051 1054 1112 -hsync -vsync
    xrandr --addmode DP-2 "1400x1050_100"
    echo "Configuring monitor defaults..."
    xrandr --output DP-1 --mode 1920x1080 --rate 100.00 --left-of DP-2 \
           --output DP-2 --mode 1920x1080 --rate 100.00 --primary
    echo "Applying saturation..."
    "$HOME/.custom-exes/cmdemo-app/cmdemo_script" DP-1 1.2
    "$HOME/.custom-exes/cmdemo-app/cmdemo_script" DP-2 1.2
 
    xrandr --output DP-2 --primary
 
    echo "Done."
fi
