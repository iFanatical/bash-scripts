#!/bin/bash
tput setaf 5; echo "GPU utilization:"
tput setaf 7; cat /sys/class/drm/card1/device/gpu_busy_percent
echo
tput setaf 5; echo "GPU frequency:"
tput setaf 7; cat /sys/class/drm/card1/device/pp_dpm_sclk
echo
tput setaf 5; echo "GPU temperature:"
tput setaf 7; cat /sys/class/drm/card1/device/hwmon/hwmon*/temp1_input
echo
tput setaf 5; echo "GPU VRAM frequency:"
tput setaf 7; cat /sys/class/drm/card1/device/pp_dpm_mclk
echo
tput setaf 5; echo "GPU VRAM usage:"
tput setaf 7; cat /sys/class/drm/card1/device/mem_info_vram_used
echo
tput setaf 5; echo "GPU VRAM size:"
tput setaf 7; cat /sys/class/drm/card1/device/mem_info_vram_total
echo
tput setaf 6; read -p "Press any key to continue..." -n 1
