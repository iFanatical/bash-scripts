#!/usr/bin/env bash
$SCRIPTS/Volume.sh --toggle
pkill -SIGRTMIN+11 waybar
