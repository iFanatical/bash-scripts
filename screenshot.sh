#!/usr/bin/env bash
# Print selects a region; Shift+Print captures the monitor under the pointer.
set -euo pipefail

mode=${1:-region}
capture_args=(--noopengl)
case "$mode" in
    region) capture_args+=(-s) ;;
    output)
        for tool in xrandr xdotool; do
            command -v "$tool" >/dev/null || {
                printf 'Screenshot requires %s for output capture\n' "$tool" >&2
                exit 1
            }
        done
        pointer=$(xdotool getmouselocation --shell)
        pointer_x=$(awk -F= '$1 == "X" { print $2 }' <<< "$pointer")
        pointer_y=$(awk -F= '$1 == "Y" { print $2 }' <<< "$pointer")
        geometry=$(xrandr --listactivemonitors | awk -v px="$pointer_x" -v py="$pointer_y" '
            NR > 1 {
                g = $3
                gsub(/\/[0-9]+/, "", g)
                split(g, size, "x")
                rest = size[2]
                h = rest + 0
                sub(/^[0-9]+/, "", rest)
                x = rest + 0
                sub(/^[+-][0-9]+/, "", rest)
                y = rest + 0
                if (px >= x && px < x + size[1] && py >= y && py < y + h) {
                    print g
                    exit
                }
            }')
        [ -n "$geometry" ] || { echo 'No monitor found under pointer' >&2; exit 1; }
        capture_args+=(-g "$geometry")
        ;;
    *) echo "Usage: $0 [region|output]" >&2; exit 2 ;;
esac

save_dir="${XDG_PICTURES_DIR:-$HOME/Pictures}/screenshots"
mkdir -p "$save_dir"
temporary=$(mktemp "${TMPDIR:-/tmp}/screenshot.XXXXXX.png")
trap 'rm -f -- "$temporary"' EXIT
if ! maim "${capture_args[@]}" "$temporary" || [ ! -s "$temporary" ]; then
    exit 0
fi
filename="$(date +'%Y-%m-%d-%H%M%S-%N_screenshotcmd.png')"
save_path="$save_dir/$filename"
mv -- "$temporary" "$save_path"
if command -v xclip >/dev/null; then
    xclip -selection clipboard -t image/png < "$save_path"
fi
if command -v notify-send >/dev/null; then
    notify-send -t 4000 -i "$save_path" "Screenshot saved: $filename"
fi
