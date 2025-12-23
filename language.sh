#!/usr/bin/env bash
LAYOUT=$(setxkbmap -query | awk '/layout/ {print $2}')
echo -e "$LAYOUT"
