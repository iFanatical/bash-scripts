#!/usr/bin/env bash
VOL=$(pamixer --get-volume)
MUTED=$(pamixer --get-mute)

MICVOL=$(pamixer --default-source --get-volume)
MICMUTED=$(pamixer --default-source --get-mute)

source "$SCRIPTS/bar-refresh.sh"
source "$SCRIPTS/bar-colors.sh"

get_vol() {
    if [ "$MUTED" = "true" ]; then
	echo "^c#ad8ee6^ muted"
    elif [ "$VOL" -le 30 ]; then
	echo "^c#7aa2f7^ $VOL%"
    elif [ "$VOL" -le 60 ]; then
	echo "^c#7aa2f7^ $VOL%"
    else
	echo "^c#7aa2f7^ $VOL%"
    fi
}

get_micvol() {
    if [ "$MICMUTED" = "true" ]; then
	echo "^c#ad8ee6^ muted"
    else
	echo "^c#7aa2f7^ $MICVOL%"
    fi
}

get_status() {
    echo "$(get_vol) $(get_micvol)"
}

case "$1" in
    --status)		get_status	;;
esac
