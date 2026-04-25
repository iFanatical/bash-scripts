#!/usr/bin/env bash
until dunstctl is-paused &>/dev/null; do
    sleep 0.5
done

DUNST=$(dunstctl is-paused 2>/dev/null)
COUNT=$(dunstctl count waiting 2>/dev/null)

if [ "$DUNST" = "false" ]; then
    echo "^c#7aa2f7^ "
elif [ "$DUNST" = "true" ]; then
    echo "^c#f7768e^  $COUNT"
fi
