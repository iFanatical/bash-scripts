#!/usr/bin/env bash
#
# random-wallpaper.sh — pick a random image from a directory and set it
# as the X background using feh.
#
# Usage: random-wallpaper.sh /path/to/wallpaper/dir
#
# If no directory is given, WALLPAPER_DIR below is used as a fallback.

set -euo pipefail

WALLPAPER_DIR="${1:-$HOME/Pictures/wallpapers}"
LOG_FILE="$HOME/.cache/random-wallpaper.log"
STATE_FILE="$HOME/.cache/random-wallpaper.last"

log() {
    printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" >> "$LOG_FILE"
}

mkdir -p "$(dirname "$LOG_FILE")"

if [ ! -d "$WALLPAPER_DIR" ]; then
    log "ERROR: directory not found: $WALLPAPER_DIR"
    exit 1
fi

# Find image files (case-insensitive extensions), null-delimited to handle spaces/newlines safely
mapfile -d '' -t IMAGES < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.bmp' -o -iname '*.webp' \) \
    -print0)

if [ "${#IMAGES[@]}" -eq 0 ]; then
    log "ERROR: no images found in $WALLPAPER_DIR"
    exit 1
fi

# Exclude the previously used image (if any) so we don't repeat it immediately
LAST_CHOSEN=""
if [ -f "$STATE_FILE" ]; then
    LAST_CHOSEN="$(cat "$STATE_FILE")"
fi

CANDIDATES=()
for img in "${IMAGES[@]}"; do
    if [ "$img" != "$LAST_CHOSEN" ]; then
        CANDIDATES+=("$img")
    fi
done

# If everything got filtered out (e.g. only one image total), fall back to the full list
if [ "${#CANDIDATES[@]}" -eq 0 ]; then
    CANDIDATES=("${IMAGES[@]}")
fi

# Pick one at random
RANDOM_INDEX=$(( RANDOM % ${#CANDIDATES[@]} ))
CHOSEN="${CANDIDATES[$RANDOM_INDEX]}"

# Make sure feh can find the X display when run from cron/.xinitrc
export DISPLAY="${DISPLAY:-:0}"

if command -v feh >/dev/null 2>&1; then
    feh --bg-fill "$CHOSEN"
    printf '%s' "$CHOSEN" > "$STATE_FILE"
    log "Set wallpaper: $CHOSEN"
else
    log "ERROR: feh is not installed"
    exit 1
fi
