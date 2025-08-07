#!/usr/bin/env bash

# Battery device
BATTERY="/org/freedesktop/UPower/devices/battery_BAT0"

# Charging icons for animation
CHARGING_ICONS=("󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅")

# Animation interval in seconds
INTERVAL=3

get_battery_percent() {
    upower -i "$BATTERY" | grep percentage | awk '{print $2}' | sed 's/%//'
}

get_charging_status() {
    upower -i "$BATTERY" | grep state | awk '{print $2}'
}

# Function to get icon based on percentage
get_battery_icon() {
    local PERCENT=$1
    if [ "$PERCENT" -le 5 ]; then
        echo "󰁺"
    elif [ "$PERCENT" -le 20 ]; then
        echo "󰁻"
    elif [ "$PERCENT" -le 40 ]; then
        echo "󰁽"
    elif [ "$PERCENT" -le 60 ]; then
        echo "󰁿"
    elif [ "$PERCENT" -le 80 ]; then
        echo "󰂁"
    elif [ "$PERCENT" -le 100 ]; then
        echo "󰁹"
    fi
}

# Main loop for Waybar output
while true; do
    PERCENT=$(get_battery_percent)
    STATUS=$(get_charging_status)

    if [ "$STATUS" = "charging" ]; then
        # Cycle through charging icons
        for ICON in "${CHARGING_ICONS[@]}"; do
            echo "{\"text\": \"$ICON $PERCENT%\", \"class\": \"charging\"}"
            sleep "$INTERVAL"
            # Check status again to break loop if no longer charging
            STATUS=$(get_charging_status)
            [ "$STATUS" != "charging" ] && break
        done
    else
        # Static icon based on percentage
        ICON=$(get_battery_icon "$PERCENT")
        echo "{\"text\": \"$ICON $PERCENT%\", \"class\": \"not-charging\"}"
        sleep "$INTERVAL"
    fi
done
