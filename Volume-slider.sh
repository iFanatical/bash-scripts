#!/bin/bash

volume=$(pamixer --get-volume)
mute=$(pamixer --get-mute)

if [ "$mute" = "true" ]; then
    icon=""  # Font Awesome mute icon
elif [ "$volume" -eq 0 ]; then
    icon=""
elif [ "$volume" -le 30 ]; then
    icon=""
elif [ "$volume" -le 70 ]; then
    icon=""
else
    icon=""  # same icon, maybe you swap for bold variant or color later
fi

echo "$icon  $volume%"