#!/usr/bin/env bash

# Prevent multiple instances
[ "${FLOCKER}" != "$0" ] && exec env FLOCKER="$0" flock -en "$0" "$0" "$@" || :

# Kill existing Waybar instances
killall waybar
sleep 1

# Get monitor names from hyprctl
MONITORS=($(hyprctl monitors -j | jq -r '.[] | .name' | sort -u))

# Debug: Print all detected monitors
#echo "Detected monitors: ${MONITORS[@]}"

# Loop through detected monitors and launch appropriate Waybar configs
for MONITOR in "${MONITORS[@]}"; do
    echo "Processing monitor: $MONITOR"
    case "$MONITOR" in
        "eDP-1")
            echo "Launching Waybar for eDP-1"
            waybar -c ~/.config/waybar/config-laptop.jsonc &
            ;;
        "DP-1")
            echo "Launching Waybar for DP-1"
            waybar -c ~/.config/waybar/config-dp1.jsonc &
            ;;
        "DP-2")
            echo "Launching Waybar for DP-2"
            waybar -c ~/.config/waybar/config-dp2.jsonc &
            ;;
        *)
            echo "Launching Waybar for unknown monitor: $MONITOR"
            waybar -c ~/.config/waybar/config-any.jsonc &
            ;;
    esac
done
