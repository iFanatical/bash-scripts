#!/usr/bin/env bash

MONITORS=($(xrandr | grep " connected" | awk '{print $1}'))

CONFIG="$HOME/.config/oxwm/config-laptop.lua"

for MONITOR in "${MONITORS[@]}"; do
    if [[ "$MONITOR" == *"DisplayPort"* || "$MONITOR" == *"HDMI"* ]]; then
        CONFIG="$HOME/.config/oxwm/config-desktop.lua"
        break
    fi
done

echo "Starting oxwm with config: $CONFIG"
exec env XDG_CURRENT_DESKTOP=oxwm dbus-launch oxwm --config $CONFIG
