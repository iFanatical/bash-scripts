#!/bin/bash

# Create a named pipe for YAD communication
pipe=$(mktemp -u --tmpdir yad.XXXXXXXX)
mkfifo "$pipe"
trap 'rm -f "$pipe"; exit 0' EXIT INT

# Function to collect system metrics and send to YAD
update_metrics() {
    cpu_temp=$(sensors | grep CPU: | cut -c 17-21 | sed 's/$/°C/')
    cpu_socket_temp=$(sensors | grep "CPU Socket:" | cut -c 17-21 | sed 's/$/°C/')
    cpu_fan_speed=$(sensors | grep "CPU Fan:" | cut -c 16-23)
    gpu_util=$(cat /sys/class/drm/card1/device/gpu_busy_percent | sed 's/$/%/')
    gpu_freq=$(cat /sys/class/drm/card1/device/pp_dpm_sclk)
    gpu_temp=$(cat /sys/class/drm/card1/device/hwmon/hwmon*/temp1_input | awk '{printf "+%.1f°C", $0/1000}')
    gpu_vram_used=$(cat /sys/class/drm/card1/device/mem_info_vram_used)
    gpu_vram_total=$(cat /sys/class/drm/card1/device/mem_info_vram_total)

    # Send metrics to YAD pipe with Pango markup for formatting
    echo "--field=<b>CPU temperature:</b>:LBL \"$cpu_temp\"" > "$pipe"
    echo "--field=<b>CPU socket temperature:</b>:LBL \"$cpu_socket_temp\"" > "$pipe"
    echo "--field=<b>CPU fan speed:</b>:LBL \"$cpu_fan_speed\"" > "$pipe"
    echo "--field=<b>GPU utilization:</b>:LBL \"$gpu_util\"" > "$pipe"
    echo "--field=<b>GPU frequency:</b>:LBL \"$gpu_freq\"" > "$pipe"
    echo "--field=<b>GPU temperature:</b>:LBL \"$gpu_temp\"" > "$pipe"
    echo "--field=<b>GPU VRAM usage:</b>:LBL \"$gpu_vram_used\"" > "$pipe"
    echo "--field=<b>GPU VRAM size:</b>:LBL \"$gpu_vram_total\"" > "$pipe"
}

# Run YAD dialog in the background, reading from the pipe
yad --form \
    --title="System Monitor" \
    --width=400 \
    --height=300 \
    --center \
    --window-icon="dialog-information" \
    --button="Close:1" \
    --timeout=3 \
    --timeout-indicator=bottom \
    --field="<b>CPU temperature:</b>:LBL" "" \
    --field="<b>CPU socket temperature:</b>:LBL" "" \
    --field="<b>CPU fan speed:</b>:LBL" "" \
    --field="<b>GPU utilization:</b>:LBL" "" \
    --field="<b>GPU frequency:</b>:LBL" "" \
    --field="<b>GPU temperature:</b>:LBL" "" \
    --field="<b>GPU VRAM usage:</b>:LBL" "" \
    --field="<b>GPU VRAM size:</b>:LBL" "" < "$pipe" &
yad_pid=$!

# Main loop to update metrics
while kill -0 $yad_pid 2>/dev/null; do
    update_metrics
    sleep 3
done

# Clean up
rm -f "$pipe"
exit 0