#!/usr/bin/env bash

CONFIG="$HOME/.config/oxwm/config-laptop.lua"

if xrandr | grep " connected" | grep -qE "DisplayPort|HDMI"; then
    CONFIG="$HOME/.config/oxwm/config-desktop.lua"
fi

echo "Starting oxwm with config: $CONFIG"
exec env XDG_CURRENT_DESKTOP=oxwm dbus-launch oxwm --config "$CONFIG"
