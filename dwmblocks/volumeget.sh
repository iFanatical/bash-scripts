#!/usr/bin/env bash

get_volume_status() {
    # variables to pull audio percent and muted status
    local GETVOL=$(amixer | awk '/^  Front Left.*Playback/ {print $5}' | sed 's/\[//;s/\%]//g')
    local MUTCHECK=$(amixer | awk '/^  Front Left.*Playback/ {print $6}' | sed 's/\[//;s/\]//g')
    # ensure GETVOL is a number
    if ! [[ "$GETVOL" =~ ^[0-9]+$ ]]; then
        echo "Error: Could not retrieve volume"
        exit 1
    fi
    # define volume stages with icons and check if muted
    if [ "$GETVOL" -eq 0 ] || [ "$MUTCHECK" == "off" ]; then
        echo " muted"
    elif [ "$GETVOL" -le 33 ]; then
        echo " $GETVOL%"
    elif [ "$GETVOL" -le 66 ]; then
        echo " $GETVOL%"
    else
        echo " $GETVOL%"
    fi
}
get_mic_status() {
    local MICCHECK=$(amixer | awk '/^  Front Left.*Capture/ {print $6}' | sed 's/\[//;s/]//g')
    local ENABLED=""
    local DISABLED=""
    local GETMICVOL=$(amixer | awk '/^  Front Left.*Capture/ {print $5}' | sed 's/\[//;s/\%]//g')
    if [ "$MICCHECK" = on ]; then
        echo $ENABLED $GETMICVOL%;
        exit 0;
    else
        echo $DISABLED muted;
        exit 0;
    fi
}
# call function and exit cleanly
echo -e $(get_volume_status) $(get_mic_status) && exit 0
