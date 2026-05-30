#!/usr/bin/env bash

TIME=$(date +"%I:%M:%S %p")
source "$SCRIPTS/bar-colors.sh"

echo "$(bar_color '#acb0d0' "󰸗 $TIME")"
