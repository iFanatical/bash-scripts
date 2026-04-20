#!/usr/bin/env bash

id=$(xdotool search --class discord | head -1);
if [ -n "$id" ]; then
    state=$(bspc query -T -n "$id" | jq -r '.hidden');
    if [ "$state" = "true" ]; then
	bspc node "$id" --flag hidden=false;
    else
	bspc node "$id" --flag hidden=true;
    fi
    else
	discord &
    fi

