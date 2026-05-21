#!/usr/bin/env bash
# bspwm-scratch.sh — dwm-style scratchpad for bspwm
#
# usage: bspwm-scratch.sh <wm-class-substring> <spawn-command>
#
# Matches windows by WM_CLASS via xprop (case-insensitive substring match).
# Set DEBUG=1 to log decisions to stderr.
#
# behavior:
#   - if no matching window exists: spawn it
#   - if hidden:                    unhide, pull to current desktop, focus
#   - if focused:                   hide it
#   - if visible but not focused:   pull to current desktop, focus

set -u

MATCH="$1"
shift
SPAWN_CMD="$*"

dbg() { [ "${DEBUG:-0}" = "1" ] && printf 'scratch: %s\n' "$*" >&2; }

find_node() {
    local match_lc="${MATCH,,}"
    local id class
    while IFS= read -r id; do
        [ -z "$id" ] && continue
        class=$(xprop -id "$id" WM_CLASS 2>/dev/null \
            | tr '[:upper:]' '[:lower:]')
        dbg "checking $id: $class"
        if [[ "$class" == *"$match_lc"* ]]; then
            dbg "match: $id"
            echo "$id"
            return 0
        fi
    done < <(bspc query -N)
    return 1
}

NODE_ID=$(find_node || true)

if [ -z "$NODE_ID" ]; then
    dbg "no match — spawning: $SPAWN_CMD"
    exec $SPAWN_CMD
fi

FOCUSED_ID=$(bspc query -N -n focused 2>/dev/null)
CUR_DESK=$(bspc query -D -d focused)

IS_HIDDEN=$(bspc query -T -n "$NODE_ID" 2>/dev/null \
    | grep -oE '"hidden"[[:space:]]*:[[:space:]]*true' || true)

dbg "node=$NODE_ID focused=$FOCUSED_ID hidden='${IS_HIDDEN:-no}' desk=$CUR_DESK"

if [ -n "$IS_HIDDEN" ]; then
    dbg "action: unhide + show"
    bspc node "$NODE_ID" -g hidden=off
    bspc node "$NODE_ID" -d "$CUR_DESK" --follow
    bspc node "$NODE_ID" -f
elif [ "$NODE_ID" = "$FOCUSED_ID" ]; then
    dbg "action: hide"
    bspc node "$NODE_ID" -g hidden=on
else
    dbg "action: pull + focus"
    bspc node "$NODE_ID" -d "$CUR_DESK" --follow
    bspc node "$NODE_ID" -f
fi
