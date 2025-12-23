#!/usr/bin/env bash

MONITORS=($(hyprctl monitors -j | jq -r '.[] | .name' | sort -u))

for MONITOR in "${MONITORS[@]}"; do
    echo "Processing monitor: $MONITOR"
    case "$MONITOR" in
        eDP-1)
            echo "Launching hyprlock for eDP-1"
            hyprlock -c ~/.config/hypr/hyprlock-laptop.conf &
            ;;
        DP-2)
            echo "Launching hyprlock for DP-2"
            hyprlock -c ~/.config/hypr/hyprlock.conf &
            ;;
        HDMI*)
            echo "Launching hyprlock for unknown monitor: $MONITOR"
            hyprlock -c ~/.config/hypr/hyprlock-hdmi.conf &
            ;;
    esac
done
