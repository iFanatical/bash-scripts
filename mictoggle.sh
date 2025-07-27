#!/usr/bin/env bash
amixer set Capture toggle
pkill -RTMIN+6 dwmblocks
