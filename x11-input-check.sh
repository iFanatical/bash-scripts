#!/usr/bin/env bash

LOGFILE="$HOME/.local/share/xorg/Xorg.0.log"
INTERVAL=5

while true; do
    clear
    echo "=== Xorg input errors @ $(date '+%H:%M:%S') ==="
    echo ""
    grep -i "syn_dropped\|lagging behind" "$LOGFILE" || echo "No issues found."
    sleep "$INTERVAL"
done
