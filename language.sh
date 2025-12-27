#!/usr/bin/env bash
echo -e "$(setxkbmap -query | awk '/layout/ {print $2}')"
