#!/usr/bin/env bash
# bar-refresh.sh — shared helper, source this from action scripts
# usage: source "$SCRIPTS/bar-refresh.sh"
#        refresh_bar <signal_number> [module_name]
#
# Sends an RT signal to dwmblocks/i3blocks, or triggers a polybar IPC hook.
# The absolute signal number (36, 37, 45, etc.) maps to the block's signal= value.
# module_name is required for polybar (the custom/ipc module name).

refresh_bar() {
    local sig="$1"
    local module="${2:-}"

    if pgrep -x dwmblocks >/dev/null 2>&1; then
        kill -"$sig" "$(pidof dwmblocks)"
    elif pgrep -x i3blocks >/dev/null 2>&1; then
        kill -"$sig" "$(pidof i3blocks)"
    elif pgrep -x polybar >/dev/null 2>&1 && [ -n "$module" ]; then
        polybar-msg action "$module" hook 0
    fi
}
