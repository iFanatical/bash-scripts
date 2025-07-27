#!/bin/bash

# Check if playerctl is installed
if ! command -v playerctl &> /dev/null; then
    echo "playerctl not found. Please install playerctl."
    exit 1
fi

# Check if dunstify is installed
if ! command -v dunstify &> /dev/null; then
    echo "dunstify not found. Please install dunst."
    exit 1
fi

# File to store the current player name
STATE_FILE="$HOME/.playerctl_cycle"
DEBUG_LOG="/tmp/control_player_debug.log"
TIMEOUT=3000

# Function to get player-specific icon
get_player_icon() {
    case "$1" in
        "spotify")
            echo "spotify"
            ;;
        "vlc")
            echo "vlc"
            ;;
        "mpv")
            echo "mpv"
            ;;
        "firefox")
            echo "firefox"
            ;;
        *)
            echo "audio-x-generic"
            ;;
    esac
}

# Check command-line argument for action
action="$1"
if [ -z "$action" ]; then
    echo "Usage: $0 {play-pause|play|pause|next|previous}"
    exit 1
fi

# Read selected player from state file
if [ -f "$STATE_FILE" ]; then
    selected_player=$(cat "$STATE_FILE")
else
    selected_player=$(playerctl --list-all 2>/dev/null | head -n 1)
    if [ -z "$selected_player" ]; then
        dunstify -u normal -t "$TIMEOUT" -i "audio-x-generic" "No media players active"
        echo "No players active" >> "$DEBUG_LOG"
        exit 0
    fi
    echo "$selected_player" > "$STATE_FILE"
    echo "Defaulted to player: $selected_player" >> "$DEBUG_LOG"
fi

# Verify player is active
if ! playerctl --list-all 2>/dev/null | grep -Fx "$selected_player" > /dev/null; then
    dunstify -u normal -t "$TIMEOUT" -i "audio-x-generic" "Player $selected_player not active"
    echo "Player $selected_player not active" >> "$DEBUG_LOG"
    selected_player=$(playerctl --list-all 2>/dev/null | head -n 1)
    if [ -z "$selected_player" ]; then
        echo "No active players" >> "$DEBUG_LOG"
        exit 0
    fi
    echo "$selected_player" > "$STATE_FILE"
    echo "Switched to new player: $selected_player" >> "$DEBUG_LOG"
fi

# Get player-specific icon
icon=$(get_player_icon "$selected_player")

# Execute the requested action
case "$action" in
    "play-pause")
        playerctl --player="$selected_player" play-pause 2>/dev/null
        status=$(playerctl --player="$selected_player" status 2>/dev/null)
        if [ "$status" = "Playing" ]; then
            dunstify -u low -t "$TIMEOUT" -i "$icon" "Playing" "$selected_player"
        elif [ "$status" = "Paused" ]; then
            dunstify -u low -t "$TIMEOUT" -i "$icon" "Paused" "$selected_player"
        else
            dunstify -u normal -t "$TIMEOUT" -i "$icon" "Player $selected_player in unknown state"
        fi
        echo "Action: play-pause, Status: $status" >> "$DEBUG_LOG"
        ;;
    "play")
        playerctl --player="$selected_player" play 2>/dev/null
        dunstify -u low -t "$TIMEOUT" -i "$icon" "Playing" "$selected_player"
        echo "Action: play" >> "$DEBUG_LOG"
        ;;
    "pause")
        playerctl --player="$selected_player" pause 2>/dev/null
        dunstify -u low -t "$TIMEOUT" -i "$icon" "Paused" "$selected_player"
        echo "Action: pause" >> "$DEBUG_LOG"
        ;;
    "next")
        playerctl --player="$selected_player" next 2>/dev/null
        dunstify -u low -t "$TIMEOUT" -i "$icon" "Next Track" "$selected_player"
        echo "Action: next" >> "$DEBUG_LOG"
        ;;
    "previous")
        playerctl --player="$selected_player" previous 2>/dev/null
        dunstify -u low -t "$TIMEOUT" -i "$icon" "Previous Track" "$selected_player"
        echo "Action: previous" >> "$DEBUG_LOG"
        ;;
    *)
        echo "Invalid action: $action" >> "$DEBUG_LOG"
        dunstify -u critical -t "$TIMEOUT" -i "audio-x-generic" "Invalid action: $action"
        exit 1
        ;;
esac