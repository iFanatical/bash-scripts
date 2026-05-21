#!/usr/bin/env bash

TIME=$(date +"%H:%M:%S")
source "$SCRIPTS/bar-colors.sh"

echo "$(bar_color '#acb0d0' "󰸗 $TIME")"
