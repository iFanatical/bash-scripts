#!/bin/bash
echo "GPU utilization:"
cat /sys/class/drm/card1/device/gpu_busy_percent
echo ""
echo "GPU frequency:"
cat /sys/class/drm/card1/device/pp_dpm_sclk
echo ""
echo "GPU temperature:"
cat /sys/class/drm/card1/device/hwmon/hwmon*/temp1_input
echo ""
echo "GPU VRAM frequency:"
cat /sys/class/drm/card1/device/pp_dpm_mclk
echo ""
echo "GPU VRAM usage:"
cat /sys/class/drm/card1/device/mem_info_vram_used
echo ""
echo "GPU VRAM size:"
cat /sys/class/drm/card1/device/mem_info_vram_total
echo ""