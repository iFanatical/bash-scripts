#!/usr/bin/env bash

COUNT=$(dunstctl count waiting)
ENABLED=""
DISABLED=""

case "$1" in
    --toggle)
        dunstctl set-paused toggle
        ;;
    --status)
        if [ "$COUNT" != "0" ]; then DISABLED=" $COUNT"; fi
        if dunstctl is-paused | grep -q "false"; then
            echo "$ENABLED"
        else
            echo "$DISABLED"
        fi
        ;;
    *)
        if [ "$COUNT" != "0" ]; then DISABLED=" $COUNT"; fi
        if dunstctl is-paused | grep -q "false"; then
            echo "$ENABLED"
        else
            echo "$DISABLED"
        fi
        ;;
esac
