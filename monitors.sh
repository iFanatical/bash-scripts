#!/bin/bash

# Check if DP-1 or DP-2 is active by looking at xrandr output
if xrandr --query | grep -E "DP-1|DP-2" | grep -q " connected [0-9]"; then
    dunstify -t 2000 -i system-suspend-hibernate "Switching to power-saving profile."
    powerprofilesctl set power-saver
    pkill -RTMIN+4 dwmblocks
    sleep 5
    xrandr --output DP-2 --off
    xrandr --output DP-1 --off
else
    # Monitors are inactive, so enable them with specified settings
    xrandr --output DP-1 --mode 1920x1080 --pos 0x180 --rotate normal --rate 144
    xrandr --output DP-2 --primary --mode 2560x1440 --pos 1920x0 --rotate normal
    $HOME/.fehbg
    sleep 5
    powerprofilesctl set performance
    pkill -RTMIN+4 dwmblocks
    dunstify -t 2000 -i system-reboot "Switching to performance profile."
fi
