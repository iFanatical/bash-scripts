#!/bin/bash

# variables
export File=-%h/.config/gpu-screen-recorder.env
export WINDOW=screen
export CONTAINER=mp4
export QUALITY=40000
export BITRATE_MODE=cbr
export CODEC=auto
export AUDIO_CODEC=opus
export AUDIO_DEVICE=default_output
export SECONDARY_AUDIO_DEVICE=
export FRAMERATE=60
export REPLAYDURATION=60
export OUTPUTDIR=%h/Videos
export MAKEFOLDERS=no
export COLOR_RANGE=limited
export KEYINT=2
export ENCODER=gpu
export RESTORE_PORTAL_SESSION=yes
export OUTPUT_RESOLUTION=0x0
export ADDITIONAL_ARGS=

# command
gpu-screen-recorder -v no -w "${WINDOW}" -s "${OUTPUT_RESOLUTION}" -c "${CONTAINER}" -q "${QUALITY}" -k "${CODEC}" -ac "${AUDIO_CODEC}" -a "${AUDIO_DEVICE}" -a "${SECONDARY_AUDIO_DEVICE}" -f "${FRAMERATE}" -r "${REPLAYDURATION}" -o "${OUTPUTDIR}" -df "${MAKEFOLDERS}" $ADDITIONAL_ARGS -cr "${COLOR_RANGE}" -keyint "${KEYINT}" -restore-portal-session "${RESTORE_PORTAL_SESSION}" -encoder "${ENCODER}" -bm "${BITRATE_MODE}" &
gsr-ui launch-daemon &
