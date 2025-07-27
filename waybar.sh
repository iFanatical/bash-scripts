#!/bin/bash

killall waybar
waybar &
waybar -c $HOME/.config/waybar/config-dp1 &