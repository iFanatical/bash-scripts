#!/usr/bin/env bash
source "$SCRIPTS/bar-colors.sh"

# window state takes precedence over desktop layout
if [ -n "$(bspc query -N -n focused.fullscreen 2>/dev/null)" ]; then
    label="[F]"
elif [ -n "$(bspc query -N -n focused.floating 2>/dev/null)" ]; then
    label="><>"
else
    DESK=$(bspc query -D -d focused --names 2>/dev/null)
    LAYOUT=$(bsp-layout get "$DESK" 2>/dev/null)

    # fall back to bspwm's native layout if bsp-layout isn't managing this desktop
    if [ -z "$LAYOUT" ]; then
        LAYOUT=$(bspc query -T -d focused 2>/dev/null \
            | grep -oE '"layout":"[^"]+"' | head -n1 \
            | grep -oE '(tiled|monocle)')
    fi

    case "$LAYOUT" in
        tall)    label="[]=" ;;
        monocle) label="[M]" ;;
        tiled)   label="[]=" ;;
        even)    label="[E]" ;;
        wide)    label="[W]" ;;
        grid)    label="[G]" ;;
        *)       label="[?]" ;;
    esac
fi

echo "$(bar_color '#7aa2f7' "$label")"
