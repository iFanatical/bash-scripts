#!/usr/bin/env bash

pgrep -f waybar &> /dev/null && killall waybar
MONITORS=($(niri msg outputs | grep -E Output | awk '{print $6}' | sed 's/(//g' | sed 's/)//g'))

for MONITOR in "${MONITORS[@]}"; do
    echo "Processing monitor: $MONITOR"
    case "$MONITOR" in
        eDP-1)
            echo "Launching Waybar for eDP-1"
            waybar -c ~/.config/waybar/niri/config-laptop.jsonc &
            ;;
        DP-1)
            echo "Launching Waybar for DP-1"
            waybar -c ~/.config/waybar/niri/config-dp1.jsonc &
            ;;
        DP-2)
            echo "Launching Waybar for DP-2"
            waybar -c ~/.config/waybar/niri/config-dp2.jsonc &
            ;;
        DP-4)
            echo "Launching Waybar for DP-4"
            waybar -c ~/.config/waybar/niri/config-dp4.jsonc &
            ;;
        DP-5)
            echo "Launching Waybar for DP-5"
            waybar -c ~/.config/waybar/niri/config-dp5.jsonc &
            ;;
        HDMI*)
            echo "Launching Waybar for unknown monitor: $MONITOR"
            waybar -c ~/.config/waybar/niri/config-any.jsonc &
            ;;
    esac
done
