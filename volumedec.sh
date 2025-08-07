#!/usr/bin/env bash
$SCRIPTS/Volume.sh --dec
pkill -SIGRTMIN+11 waybar
