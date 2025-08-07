#!/usr/bin/env bash
amixer set Capture toggle
pkill -SIGRTMIN+11 waybar
