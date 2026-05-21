#!/usr/bin/env bash
# bar-refresh.sh — shared helper, source this from action scripts
# usage: source "$SCRIPTS/bar-refresh.sh"
#        refresh_bar <signal_number>
#
# Sends an RT signal to whichever block-style status bar is running.
# Use the absolute signal number (36, 37, 45, etc.) — the same number works
# for both dwmblocks and i3blocks because i3blocks signal=N maps to RTMIN+N,
# so set i3blocks signal=4 to receive absolute signal 36, signal=5 for 37, etc.

refresh_bar() {
    local sig="$1"

    if pgrep -x dwmblocks >/dev/null 2>&1; then
        kill -"$sig" $(pidof dwmblocks)
    elif pgrep -x i3blocks >/dev/null 2>&1; then
        kill -"$sig" $(pidof i3blocks)
    fi
}
