#!/usr/bin/env bash

pgrep -f waybar &> /dev/null && killall waybar
MONITORS=($(hyprctl monitors -j | jq -r '.[] | .name' | sort -u))

for MONITOR in "${MONITORS[@]}"; do
    echo "Processing monitor: $MONITOR"
    case "$MONITOR" in
        eDP-1)
            echo "Launching Waybar for eDP-1"
            waybar -c ~/.config/waybar/config-laptop.jsonc &
            ;;
        DP-1)
            echo "Launching Waybar for DP-1"
            waybar -c ~/.config/waybar/config-dp1.jsonc &
            ;;
        DP-2)
            echo "Launching Waybar for DP-2"
            waybar -c ~/.config/waybar/config-dp2.jsonc &
            ;;
        DP-4)
            echo "Launching Waybar for DP-4"
            waybar -c ~/.config/waybar/config-dp4.jsonc &
            ;;
        HDMI*)
            echo "Launching Waybar for unknown monitor: $MONITOR"
            waybar -c ~/.config/waybar/config-any.jsonc &
            ;;
    esac
done
