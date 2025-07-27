#!/bin/bash

# Trap Ctrl+C for clean exit
trap 'echo -e "\nScript terminated."; tput sgr0; exit 0' INT

while :; do
    # Clear the screen
    clear

    # Display system information
    tput setaf 5; echo "CPU temperature:"
    tput setaf 7; sensors | grep CPU: | cut -c 17-21 | sed '$s/$/°C/'
    tput setaf 5; echo "CPU socket temperature:"
    tput setaf 7; sensors | grep "CPU Socket:" | cut -c 17-21 | sed '$s/$/°C/'
    tput setaf 5; echo "CPU fan speed:"
    tput setaf 7; sensors | grep "CPU Fan:" | cut -c 16-23
    echo "---------------------------"
    tput setaf 5; echo "GPU utilization:"
    tput setaf 7; cat /sys/class/drm/card1/device/gpu_busy_percent | sed '$s/$/%/'
    tput setaf 5; echo "GPU frequency:"
    tput setaf 7; cat /sys/class/drm/card1/device/pp_dpm_sclk
    tput setaf 5; echo "GPU temperature:"
    tput setaf 7; cat /sys/class/drm/card1/device/hwmon/hwmon*/temp1_input | awk '{printf "+%.1f\n", $0/1000}' | sed '$s/$/°C/'
    tput setaf 5; echo "GPU VRAM usage:"
    tput setaf 7; cat /sys/class/drm/card1/device/mem_info_vram_used
    tput setaf 5; echo "GPU VRAM size:"
    tput setaf 7; cat /sys/class/drm/card1/device/mem_info_vram_total
	echo "---------------------------"
    # Display interrupt message
    tput setaf 3; echo "Press any key to interrupt..."
    tput sgr0

    # Check for keypress (non-blocking, timeout matches sleep duration)
    if read -t 3 -n 1 -s; then
        echo -e "\nScript interrupted by keypress."
        tput sgr0
        exit 0
    fi
done