#!/usr/bin/env bash
VOL=$(pamixer --get-volume)
MUTED=$(pamixer --get-mute)

if [ "$MUTED" = "true" ]; then
    echo "^c#ad8ee6^ muted"
elif [ "$VOL" -le 30 ]; then
    echo "^c#7aa2f7^ $VOL%"
elif [ "$VOL" -le 60 ]; then
    echo "^c#7aa2f7^ $VOL%"
else
    echo "^c#7aa2f7^ $VOL%"
fi
