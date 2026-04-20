#!/usr/bin/env bash

iDIR="$HOME/.local/bin/icons"
sDIR="$HOME/.local/bin/scripts"

# Get Volume
get_volume() {
    volume=$(pamixer --get-volume)
    if [[ "$volume" -eq "0" ]]; then
        echo "Muted"
    else
        echo "$volume%"
    fi
}

# Get Icon
get_icon() {
    current=$(get_volume)
    if [[ "$current" == "Muted" ]]; then
        echo "$iDIR/volume-mute.png"
    elif [[ "${current%\%}" -le 30 ]]; then
        echo "$iDIR/volume-low.png"
    elif [[ "${current%\%}" -le 60 ]]; then
        echo "$iDIR/volume-mid.png"
    else
        echo "$iDIR/volume-high.png"
    fi
}

# Notify — volume
notify_user() {
    local vol icon
    vol=$(get_volume)
    icon=$(get_icon)

    if [[ "$vol" == "Muted" ]]; then
        notify-send -e \
            -a "volume" \
            -u low \
            -i "$icon" \
            -h string:x-canonical-private-synchronous:volume_notif \
            " Volume" "Muted"
    else
        notify-send -e \
            -a "volume" \
            -u low \
            -i "$icon" \
            -h string:x-canonical-private-synchronous:volume_notif \
            -h int:value:"${vol%\%}" \
            " Volume" "$vol" &&
        "$sDIR/Sounds.sh" --volume
    fi
}

# Increase Volume
inc_volume() {
    if [[ "$(pamixer --get-mute)" == "true" ]]; then
        toggle_mute
    else
        pamixer -i 5 --allow-boost --set-limit 150 && notify_user
    fi
}

# Decrease Volume
dec_volume() {
    if [[ "$(pamixer --get-mute)" == "true" ]]; then
        toggle_mute
    else
        pamixer -d 5 && notify_user
    fi
}

# Toggle Mute
toggle_mute() {
    if [[ "$(pamixer --get-mute)" == "false" ]]; then
        pamixer -m
        notify-send -e \
            -a "volume" \
            -u low \
            -i "$iDIR/volume-mute.png" \
            -h string:x-canonical-private-synchronous:volume_notif \
            " Volume" "Muted"
    elif [[ "$(pamixer --get-mute)" == "true" ]]; then
        pamixer -u
        notify-send -e \
            -a "volume" \
            -u low \
            -i "$(get_icon)" \
            -h string:x-canonical-private-synchronous:volume_notif \
            " Volume" "Unmuted"
    fi
}

# Get Mic Icon
get_mic_icon() {
    if [[ "$(pamixer --default-source --get-mute)" == "true" ]]; then
        echo "$iDIR/microphone-mute.png"
    else
        echo "$iDIR/microphone.png"
    fi
}

# Get Mic Volume
get_mic_volume() {
    volume=$(pamixer --default-source --get-volume)
    if [[ "$(pamixer --default-source --get-mute)" == "true" ]]; then
        echo "Muted"
    else
        echo "$volume%"
    fi
}

# Notify — mic
notify_mic_user() {
    local vol icon
    vol=$(get_mic_volume)
    icon=$(get_mic_icon)

    if [[ "$vol" == "Muted" ]]; then
        notify-send -e \
            -a "volume" \
            -u low \
            -i "$icon" \
            -h string:x-canonical-private-synchronous:volume_notif \
            " Microphone" "Muted"
    else
        notify-send -e \
            -a "volume" \
            -u low \
            -i "$icon" \
            -h string:x-canonical-private-synchronous:volume_notif \
            -h int:value:"${vol%\%}" \
            " Microphone" "$vol"
    fi
}

# Toggle Mic
toggle_mic() {
    if [[ "$(pamixer --default-source --get-mute)" == "false" ]]; then
        pamixer --default-source -m && notify_mic_user
    elif [[ "$(pamixer --default-source --get-mute)" == "true" ]]; then
        pamixer --default-source -u && notify_mic_user
    fi
}

# Increase Mic Volume
inc_mic_volume() {
    if [[ "$(pamixer --default-source --get-mute)" == "true" ]]; then
        toggle_mic
    else
        pamixer --default-source -i 5 && notify_mic_user
    fi
}

# Decrease Mic Volume
dec_mic_volume() {
    if [[ "$(pamixer --default-source --get-mute)" == "true" ]]; then
        toggle_mic
    else
        pamixer --default-source -d 5 && notify_mic_user
    fi
}

# Execute
case "$1" in
    --get)          get_volume ;;
    --inc)          inc_volume ;;
    --dec)          dec_volume ;;
    --toggle)       toggle_mute ;;
    --toggle-mic)   toggle_mic ;;
    --get-icon)     get_icon ;;
    --get-mic-icon) get_mic_icon ;;
    --mic-inc)      inc_mic_volume ;;
    --mic-dec)      dec_mic_volume ;;
    *)              get_volume ;;
esac
