#!/bin/bash
dunstctl set-paused toggle
pkill -RTMIN+5 dwmblocks
