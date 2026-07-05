#!/usr/bin/env bash

source "$SCRIPTS/bar-colors.sh"
source "$SCRIPTS/bar-refresh.sh"

COUNT=$(dunstctl count waiting)

case "$1" in
    --toggle)
        dunstctl set-paused toggle
        sleep 0.1
        refresh_bar 38 dunst
        ;;
    --status|*)
        if dunstctl is-paused | grep -q "false"; then
            echo "$(bar_color '#7aa2f7' '')"
        else
            echo "$(bar_color '#f7768e' " $COUNT")"
        fi
        ;;
esac
