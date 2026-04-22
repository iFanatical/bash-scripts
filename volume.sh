#!/usr/bin/env bash
VOL=$(pamixer --get-volume)
MUTED=$(pamixer --get-mute)

MICVOL=$(pamixer --default-source --get-volume)
MICMUTED=$(pamixer --default-source --get-mute)

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

get_voltoggle() {
    if [ "$MUTED" = "true" ]; then
	pamixer -u
    else
	pamixer -m
    fi
}

get_micvol() {
    if [ "$MICMUTED" = "true" ]; then
	echo "^c#ad8ee6^ muted"
    else
	echo "^c#7aa2f7^ $MICVOL%"
    fi
}

get_mictoggle() {
    if [ "$MICMUTED" = "false" ]; then
	pamixer --default-source -m
    else
	pamixer --default-source -u
    fi
}

get_mictoggle() {
    if [ "$MICMUTED" = "false" ]; then
	pamixer --default-source -m
    else
	pamixer --default-source -u
    fi
}

inc_vol() {
    if [[ "$(pamixer --get-mute)" == "true" ]]; then
        toggle_mute
    else
        pamixer -i 5 --allow-boost --set-limit 100
    fi
}

dec_vol() {
    if [[ "$(pamixer --get-mute)" == "true" ]]; then
        toggle_mute
    else
        pamixer -d 5
    fi
}

get_status() {
    echo "$(get_vol) $(get_micvol)"
}

case "$1" in
    --status)		get_status	;;
    --getvol)		get_vol		;;
    --toggle)		get_voltoggle	;;
    --getmicvol)	get_micvol	;;
    --togglemic)	get_mictoggle	;;
    --inc)		inc_vol		;;
    --dec)		dec_vol		;;
esac
