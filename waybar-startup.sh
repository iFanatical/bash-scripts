#!/bin/bash

# Kill existing Waybar
killall waybar

# Get number of connected monitors
MONITOR_COUNT=$(hyprctl monitors -j | jq length)

# Use different config depending on number of monitors
if [ "$MONITOR_COUNT" -eq 1 ]; then
    # echo "Single monitor setup detected."
    waybar -c ~/.config/waybar/config-laptop &
elif [ "$MONITOR_COUNT" -eq 2 ]; then
    # echo "Dual monitor setup detected."
    waybar -c ~/.config/waybar/config-dp1 &
    waybar -c ~/.config/waybar/config-dp2 &
else
    # echo "More than two monitors detected."
    waybar -c ~/.config/waybar/config-any &
fi
