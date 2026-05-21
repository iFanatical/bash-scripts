#!/usr/bin/env bash
# bar-colors.sh — emit color escapes for the active status bar
# source this from any status script that outputs colored text
#
# usage:
#   source "$SCRIPTS/bar-colors.sh"
#   echo "$(bar_color '#9ece6a' '󰕥 connected')"
#
# detection:
#   - $BAR env var if set (values: dwmblocks, i3blocks, none)
#   - otherwise pgrep check
#
# behavior:
#   - dwmblocks: emits ^c#RRGGBB^TEXT
#   - i3blocks:  emits <span color="#RRGGBB">TEXT</span>  (requires markup=pango)
#   - unknown:   emits plain TEXT

bar_detect() {
    if [ -n "${BAR:-}" ]; then
        echo "$BAR"
    elif pgrep -x dwmblocks >/dev/null 2>&1; then
        echo dwmblocks
    elif pgrep -x i3blocks >/dev/null 2>&1; then
        echo i3blocks
    else
        echo none
    fi
}

bar_color() {
    local color="$1"
    local text="$2"
    case "$(bar_detect)" in
        dwmblocks) printf '^c%s^%s' "$color" "$text" ;;
        i3blocks)  printf '<span color="%s">%s</span>' "$color" "$text" ;;
        *)         printf '%s' "$text" ;;
    esac
}
