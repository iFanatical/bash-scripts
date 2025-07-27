#!/usr/bin/env bash
$SCRIPTS/Volume.sh --toggle
pkill -RTMIN+6 dwmblocks
