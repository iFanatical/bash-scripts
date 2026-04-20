#!/usr/bin/env bash
KBD=$(setxkbmap -query | awk '/layout/ {print $2}')
echo -e "^c#f7768e^ $KBD"
