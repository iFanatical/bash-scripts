#!/usr/bin/env bash
# get_brightness.sh — Output current brightness as a percentage

set -euo pipefail

TARGET_DEVICE="intel_backlight"
RED="\033[31m"
RESET="\033[0m"

if command -v brightnessctl &>/dev/null; then
    current=$(brightnessctl -d "$TARGET_DEVICE" get 2>/dev/null || echo "N/A")
    max=$(brightnessctl -d "$TARGET_DEVICE" max 2>/dev/null || echo "N/A")

    if [[ "$current" != "N/A" && "$max" != "N/A" && "$max" -gt 0 ]]; then
        echo $(( current * 100 / max ))%
    else
        echo -e "${RED}Error: could not read '$TARGET_DEVICE'.${RESET}" >&2
        exit 1
    fi

elif command -v ddcutil &>/dev/null; then
    brightness_line=$(ddcutil --display 1 getvcp 0x10 2>/dev/null || echo "")
    current=$(echo "$brightness_line" | grep -oP 'current value =\s*\K\d+' || echo "N/A")
    max=$(echo "$brightness_line" | grep -oP 'max value =\s*\K\d+' || echo "N/A")

    if [[ "$current" != "N/A" && "$max" != "N/A" && "$max" -gt 0 ]]; then
        echo $(( current * 100 / max ))%
    else
        echo -e "${RED}Error: could not read brightness via ddcutil.${RESET}" >&2
        exit 1
    fi

else
    echo -e "${RED}Error: neither brightnessctl nor ddcutil found.${RESET}" >&2
    exit 1
fi
