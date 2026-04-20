#!/usr/bin/env bash

iDIR="$HOME/.local/bin/icons"

# Get Mic Mute State
get_mute() {
    pamixer --default-source --get-mute
}

# Get Mic Volume
get_mic_volume() {
    volume=$(pamixer --default-source --get-volume)
    if [[ "$(get_mute)" == "true" ]]; then
        echo "Muted"
    else
        echo "$volume%"
    fi
}

# Get Mic Icon
get_mic_icon() {
    if [[ "$(get_mute)" == "true" ]]; then
        echo "$iDIR/microphone-mute.png"
    else
        echo "$iDIR/microphone.png"
    fi
}

# Notify
notify_user() {
    local vol icon
    vol=$(get_mic_volume)
    icon=$(get_mic_icon)

    if [[ "$vol" == "Muted" ]]; then
        notify-send -e \
            -a "volume" \
            -u low \
            -i "$icon" \
            -h string:x-canonical-private-synchronous:mic_notif \
            " Microphone" "Muted"
    else
        notify-send -e \
            -a "volume" \
            -u low \
            -i "$icon" \
            -h string:x-canonical-private-synchronous:mic_notif \
            -h int:value:"${vol%\%}" \
            " Microphone" "$vol"
    fi
}

# Toggle Mute
toggle_mute() {
    if [[ "$(get_mute)" == "false" ]]; then
        pamixer --default-source -m && notify_user
    elif [[ "$(get_mute)" == "true" ]]; then
        pamixer --default-source -u && notify_user
    fi
}

# Increase Mic Volume
inc_mic_volume() {
    if [[ "$(get_mute)" == "true" ]]; then
        toggle_mute
    else
        pamixer --default-source -i 5 && notify_user
    fi
}

# Decrease Mic Volume
dec_mic_volume() {
    if [[ "$(get_mute)" == "true" ]]; then
        toggle_mute
    else
        pamixer --default-source -d 5 && notify_user
    fi
}

# Execute
case "$1" in
    --get)          get_mic_volume ;;
    --get-icon)     get_mic_icon ;;
    --toggle)       toggle_mute ;;
    --inc)          inc_mic_volume ;;
    --dec)          dec_mic_volume ;;
    *)              get_mic_volume ;;
esac
