#!/usr/bin/env bash

# Set stretched resolution
echo "Changing DP-2 resolution..."
hyprctl keyword monitor DP-2,1280x960@100,auto,1

sleep 5
echo "Launching cs2..."
steam -applaunch 730
sleep 10
echo "cs2 running..."

while pgrep -x "cs2" > /dev/null; do
    sleep 5
done

# Restore native resolution
echo "Restoring resolution..."
hyprctl keyword monitor DP-2,1920x1080@100,auto,1
echo "Good game!"
