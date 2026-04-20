#!/usr/bin/env bash

current_gaps=$(hyprctl getoption general:gaps_in | grep "custom type:" | awk '{print $3}')

if [ "$current_gaps" -eq 0 ]; then
    hyprctl keyword general:gaps_in 2.5
    hyprctl keyword general:gaps_out 5
else
    hyprctl keyword general:gaps_in 0
    hyprctl keyword general:gaps_out 0
fi
