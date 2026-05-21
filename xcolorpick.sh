#!/usr/bin/env bash
# colorpick.sh — pick a screen color with xcolor, copy to clipboard,
# and send a dunst notification with a swatch of the chosen color.

set -euo pipefail

# Ensure required tools are available
for cmd in xcolor xclip notify-send; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        notify-send -u critical "colorpick" "Missing dependency: $cmd"
        echo "Error: $cmd is not installed." >&2
        exit 1
    fi
done

# Pick a color (xcolor returns "#RRGGBB"); abort cleanly if the user cancels.
color="$(xcolor)" || exit 0
[ -z "$color" ] && exit 0

# Copy to both the X selection and the clipboard so it works everywhere.
printf '%s' "$color" | xclip -selection clipboard
printf '%s' "$color" | xclip -selection primary

# Build a small swatch PNG for the notification icon.
icon_dir="${XDG_CACHE_HOME:-$HOME/.cache}/colorpick"
mkdir -p "$icon_dir"
icon="$icon_dir/swatch.png"

if command -v convert >/dev/null 2>&1; then
    convert -size 32x32 "xc:${color}" "$icon"
    notify-send -i "$icon" -a colorpick "Color copied" "$color"
else
    # Fall back to a plain notification if ImageMagick isn't around.
    notify-send -a colorpick "Color copied" "$color"
fi
