#!/usr/bin/env bash
$SCRIPTS/Volume.sh --inc
pkill -SIGRTMIN+11 waybar
