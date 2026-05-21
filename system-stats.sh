#!/usr/bin/env bash
source "$SCRIPTS/bar-colors.sh"

memuse=$(free -m | awk '/^Mem/ {print ($3)/1000}' | cut -c-4)
echo "$(bar_color '#acb0d0' " $memuse GiB")"
