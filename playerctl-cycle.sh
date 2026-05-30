#!/usr/bin/env bash
# playerctl-cycle: cycle between MPRIS players and control them
#
# Usage:
#   playerctl-cycle next         # select next available player
#   playerctl-cycle prev         # select previous available player
#   playerctl-cycle play-pause   # toggle play/pause on active player
#   playerctl-cycle play         # play active player
#   playerctl-cycle pause        # pause active player
#   playerctl-cycle stop         # stop active player
#   playerctl-cycle forward      # next track on active player
#   playerctl-cycle backward     # previous track on active player
#   playerctl-cycle status       # show which player is active
#   playerctl-cycle list         # list all available players
#
# State (active player name) is persisted in $XDG_RUNTIME_DIR.

set -euo pipefail

STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}"
STATE_FILE="$STATE_DIR/playerctl-cycle.active"
NOTIF_ID_FILE="$STATE_DIR/playerctl-cycle.notif-id"
# Stable notification id so each new notification replaces the previous one
# instead of stacking up in the Dunst history.
if [[ -f "$NOTIF_ID_FILE" ]]; then
    NOTIF_ID="$(cat "$NOTIF_ID_FILE")"
else
    NOTIF_ID=$(( (RANDOM % 9000) + 1000 ))
    echo "$NOTIF_ID" > "$NOTIF_ID_FILE"
fi

# ---------- helpers ----------

# Return all currently running players, one per line.
list_players() {
    playerctl -l 2>/dev/null || true
}

# Read saved active player, or empty if none/stale.
get_active() {
    [[ -f "$STATE_FILE" ]] || { echo ""; return; }
    local saved
    saved="$(cat "$STATE_FILE")"
    # If the saved player is no longer running, discard it.
    if list_players | grep -Fxq "$saved"; then
        echo "$saved"
    else
        echo ""
    fi
}

set_active() {
    echo "$1" > "$STATE_FILE"
}

# Pretty name for a player id like "brave.instance123" -> "Brave"
pretty_name() {
    local p="$1"
    # Strip ".instance..." suffix that Chromium-based players add
    p="${p%%.instance*}"
    # Capitalize first letter
    printf '%s' "${p^}"
}

# Icon hint for `notify-send -i`. Most players ship a desktop icon
# matching their lowercase name, which Dunst will resolve via the theme.
icon_for() {
    local p="$1"
    p="${p%%.instance*}"
    case "$p" in
        brave|brave-browser) echo "brave-browser" ;;
        chrome|chromium|google-chrome) echo "google-chrome" ;;
        firefox) echo "firefox" ;;
        vlc) echo "vlc" ;;
        spotify) echo "spotify" ;;
        mpv) echo "mpv" ;;
        feishin) echo "feishin" ;;
        *) echo "$p" ;;
    esac
}

# Status of a specific player ("Playing" / "Paused" / "Stopped" / "")
player_status() {
    playerctl -p "$1" status 2>/dev/null || true
}

# Metadata "Artist - Title" if available, else just the title, else empty.
player_track() {
    local p="$1" artist title
    artist="$(playerctl -p "$p" metadata xesam:artist 2>/dev/null || true)"
    title="$(playerctl -p "$p" metadata xesam:title 2>/dev/null || true)"
    if [[ -n "$artist" && -n "$title" ]]; then
        printf '%s — %s' "$artist" "$title"
    elif [[ -n "$title" ]]; then
        printf '%s' "$title"
    fi
}

notify() {
    local title="$1" body="$2" icon="${3:-audio-x-generic}"
    # -r reuses the same notification slot; -t sets timeout in ms.
    notify-send -r "$NOTIF_ID" -t 2500 -i "$icon" -a "playerctl-cycle" \
        "$title" "$body" 2>/dev/null || true
}

notify_active() {
    local p
    p="$(get_active)"
    if [[ -z "$p" ]]; then
        notify "playerctl" "No active player" "audio-x-generic"
        return
    fi
    local status track body
    status="$(player_status "$p")"
    track="$(player_track "$p")"
    body="${status:-Unknown}"
    [[ -n "$track" ]] && body+=$'\n'"$track"
    notify "▶ $(pretty_name "$p")" "$body" "$(icon_for "$p")"
}

# Cycle: $1 = "next" or "prev"
cycle() {
    local dir="$1"
    mapfile -t players < <(list_players)
    if (( ${#players[@]} == 0 )); then
        notify "playerctl" "No players running" "dialog-error"
        exit 0
    fi

    local current idx=-1
    current="$(get_active)"
    if [[ -n "$current" ]]; then
        for i in "${!players[@]}"; do
            [[ "${players[$i]}" == "$current" ]] && idx=$i && break
        done
    fi

    local n=${#players[@]} new_idx
    if [[ "$dir" == "next" ]]; then
        new_idx=$(( (idx + 1) % n ))
    else
        new_idx=$(( (idx - 1 + n) % n ))
    fi

    set_active "${players[$new_idx]}"
    notify_active
}

# Ensure we have an active player; if none, pick the first running one.
ensure_active() {
    local p
    p="$(get_active)"
    if [[ -z "$p" ]]; then
        p="$(list_players | head -n1)"
        if [[ -z "$p" ]]; then
            notify "playerctl" "No players running" "dialog-error"
            exit 0
        fi
        set_active "$p"
    fi
    echo "$p"
}

control() {
    local action="$1" p
    p="$(ensure_active)"
    playerctl -p "$p" "$action" 2>/dev/null || {
        notify "playerctl" "Failed: $action on $(pretty_name "$p")" "dialog-error"
        exit 1
    }
    # Small delay so the status query reflects the new state.
    sleep 0.05
    notify_active
}

# ---------- main ----------

case "${1:-}" in
    next)        cycle next ;;
    prev|previous) cycle prev ;;
    play-pause|toggle) control play-pause ;;
    play)        control play ;;
    pause)       control pause ;;
    stop)        control stop ;;
    forward|next-track) control next ;;
    backward|prev-track|previous-track) control previous ;;
    status)      notify_active ;;
    list)
        mapfile -t players < <(list_players)
        if (( ${#players[@]} == 0 )); then
            echo "No players running."
            exit 0
        fi
        active="$(get_active)"
        for p in "${players[@]}"; do
            marker="  "
            [[ "$p" == "$active" ]] && marker="* "
            printf '%s%-40s %s\n' "$marker" "$p" "$(player_status "$p")"
        done
        ;;
    ""|-h|--help|help)
        sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'
        ;;
    *)
        echo "Unknown command: $1" >&2
        echo "Run '$0 help' for usage." >&2
        exit 2
        ;;
esac
