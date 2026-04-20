#!/usr/bin/env bash

iDIR="$HOME/.local/bin/icons"

# DDC monitor I2C bus numbers — adjust to match 'ddcutil detect' output
I2C_BUS1=7
I2C_BUS2=8

# Get brightnessctl current brightness as a percentage
get_backlight() {
    brightnessctl -m | awk -F, '{gsub(/%/, "", $4); print $4"%"}'
}

# Get DDC current brightness as a percentage
get_ddc() {
    local info current max
    info=$(ddcutil getvcp 0x10 --bus "$I2C_BUS1" 2>/dev/null)
    current=$(echo "$info" | grep -oP 'current value =\s*\K\d+')
    max=$(echo "$info" | grep -oP 'max value =\s*\K\d+')

    if [[ -z "$current" || -z "$max" ]]; then
        echo "N/A"
        return 1
    fi

    echo "$(( (current * 100) / max ))%"
}

# Get brightness icon based on percentage value (no % sign)
get_icon() {
    local level="$1"
    if [[ "$level" -le 0 ]]; then
        echo "$iDIR/brightness-off.png"
    elif [[ "$level" -le 30 ]]; then
        echo "$iDIR/brightness-low.png"
    elif [[ "$level" -le 60 ]]; then
        echo "$iDIR/brightness-mid.png"
    else
        echo "$iDIR/brightness-high.png"
    fi
}

# Notify — backlight (brightnessctl)
notify_backlight() {
    local val icon
    val=$(get_backlight)
    icon=$(get_icon "${val%\%}")

    notify-send -e \
        -a "brightness" \
        -u low \
        -i "$icon" \
        -h string:x-canonical-private-synchronous:brightness_notif \
        -h int:value:"${val%\%}" \
        " Brightness" "$val"
}

# Notify — DDC (external monitors)
notify_ddc() {
    local val icon
    val=$(get_ddc)
    icon=$(get_icon "${val%\%}")

    notify-send -e \
        -a "brightness" \
        -u low \
        -i "$icon" \
        -h string:x-canonical-private-synchronous:brightness_notif \
        -h int:value:"${val%\%}" \
        " Monitor Brightness" "$val"
}

# Increase backlight
bc_up() {
    brightnessctl -e4 -n2 set 5%+ && notify_backlight
}

# Decrease backlight (minimum raw value ~1200 to prevent screen becoming invisible)
bc_down() {
    local current min_raw=1200
    current=$(brightnessctl info | grep -oP 'Current brightness: \K\d+')

    if [[ "$current" -le "$min_raw" ]]; then
        brightnessctl -e4 -n2 set "$min_raw" && notify_backlight
    else
        brightnessctl -e4 -n2 set 5%- && notify_backlight
    fi
}

# Increase DDC brightness
ddc_up() {
    local info current max new_val
    info=$(ddcutil getvcp 0x10 --bus "$I2C_BUS1" 2>/dev/null)
    current=$(echo "$info" | grep -oP 'current value =\s*\K\d+')
    max=$(echo "$info" | grep -oP 'max value =\s*\K\d+')

    if [[ -z "$current" || -z "$max" ]]; then
        notify-send -e -a "brightness" -u critical " Monitor Brightness" "Could not reach display — check I2C bus"
        exit 1
    fi

    new_val=$(( current + 10 ))
    [[ "$new_val" -gt "$max" ]] && new_val="$max"

    ddcutil setvcp 0x10 "$new_val" --bus "$I2C_BUS1"
    ddcutil setvcp 0x10 "$new_val" --bus "$I2C_BUS2"
    notify_ddc
}

# Decrease DDC brightness
ddc_down() {
    local info current max new_val
    info=$(ddcutil getvcp 0x10 --bus "$I2C_BUS1" 2>/dev/null)
    current=$(echo "$info" | grep -oP 'current value =\s*\K\d+')
    max=$(echo "$info" | grep -oP 'max value =\s*\K\d+')

    if [[ -z "$current" || -z "$max" ]]; then
        notify-send -e -a "brightness" -u critical " Monitor Brightness" "Could not reach display — check I2C bus"
        exit 1
    fi

    new_val=$(( current - 10 ))
    [[ "$new_val" -lt 0 ]] && new_val=0

    ddcutil setvcp 0x10 "$new_val" --bus "$I2C_BUS1"
    ddcutil setvcp 0x10 "$new_val" --bus "$I2C_BUS2"
    notify_ddc
}

# Execute
case "$1" in
    --bcup)         bc_up ;;
    --bcdown)       bc_down ;;
    --ddcup)        ddc_up ;;
    --ddcdown)      ddc_down ;;
    --get)          get_backlight ;;
    --get-ddc)      get_ddc ;;
    --get-icon)     get_icon "${2:-50}" ;;
    *)
        echo "Usage: $(basename "$0") {--bcup|--bcdown|--ddcup|--ddcdown|--get|--get-ddc}"
        exit 1
        ;;
esac
