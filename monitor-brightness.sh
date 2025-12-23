#!/usr/bin/env bash

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 {up|down}"
    exit 1
fi

# Configuration: Replace with your monitor's I2C bus number from 'ddcutil detect'
I2C_BUS1=7
I2C_BUS2=8

# Get current brightness and max brightness
BRIGHTNESS_INFO=$(ddcutil getvcp 0x10 --bus $I2C_BUS1)
CURRENT_BRIGHTNESS=$(echo "$BRIGHTNESS_INFO" | grep -oP 'current value =\s*\K\d+')
MAX_BRIGHTNESS=$(echo "$BRIGHTNESS_INFO" | grep -oP 'max value =\s*\K\d+')

# Check if brightness info was retrieved successfully
if [ -z "$CURRENT_BRIGHTNESS" ] || [ -z "$MAX_BRIGHTNESS" ]; then
    echo "Error: Could not retrieve brightness information. Check I2C bus number and monitor compatibility."
    exit 1
fi

# Calculate new brightness
case "$1" in
    up)
        NEW_BRIGHTNESS=$((CURRENT_BRIGHTNESS + 10))
        ;;
    down)
        NEW_BRIGHTNESS=$((CURRENT_BRIGHTNESS - 10))
        ;;
    *)
        echo "Invalid argument: Use 'up' or 'down'"
        exit 1
        ;;
esac

# Ensure brightness stays within bounds (0 to MAX_BRIGHTNESS)
if [ "$NEW_BRIGHTNESS" -lt 0 ]; then
    NEW_BRIGHTNESS=0
elif [ "$NEW_BRIGHTNESS" -gt "$MAX_BRIGHTNESS" ]; then
    NEW_BRIGHTNESS="$MAX_BRIGHTNESS"
fi

# Set new brightness
ddcutil setvcp 0x10 "$NEW_BRIGHTNESS" --bus "$I2C_BUS1"
ddcutil setvcp 0x10 "$NEW_BRIGHTNESS" --bus "$I2C_BUS2"

# Calculate percentage, and output to Dunst
PERCENTAGE=$(( (NEW_BRIGHTNESS * 100) / MAX_BRIGHTNESS ))
dunstify -a "Brightness" -u low -t 2000 -r 1000 -h int:value:$PERCENTAGE "Monitor brightness: $PERCENTAGE%"

echo "Brightness set to $NEW_BRIGHTNESS"
