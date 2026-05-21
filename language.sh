#!/usr/bin/env bash
source "$SCRIPTS/bar-colors.sh"
KBD=$(setxkbmap -query | awk '/layout/ {print $2}')
echo "$(bar_color '#f7768e' " $KBD")"
