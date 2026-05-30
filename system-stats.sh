#!/usr/bin/env bash
source "$SCRIPTS/bar-colors.sh"

memuse=$(free -m | awk '/^Mem/ {print ($3)/1000}' | cut -c-4)
echo "$(bar_color '#ff9e64' " $memuse GiB")"
