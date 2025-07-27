#!/bin/bash

# Notification timeout in milliseconds (e.g., 3000 = 3 seconds)
TIMEOUT=3000

# File to store the current player name
STATE_FILE="$HOME/.playerctl_cycle"
DEBUG_LOG="/tmp/media_notification_debug.log"

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

# Function to get player status and metadata
get_media_info() {
    # Read selected player from state file
    if [ -f "$STATE_FILE" ]; then
        selected_player=$(cat "$STATE_FILE")
    else
        selected_player=$(playerctl --list-all 2>/dev/null | head -n 1)
        if [ -z "$selected_player" ]; then
            dunstify -u normal -t "$TIMEOUT" -i "audio-x-generic" -r 1000 "No media players active"
            echo "No players active" >> "$DEBUG_LOG"
            exit 0
        fi
        echo "$selected_player" > "$STATE_FILE"
        echo "Defaulted to player: $selected_player" >> "$DEBUG_LOG"
    fi

    # Verify player is still active
    if ! playerctl --list-all 2>/dev/null | grep -Fx "$selected_player" > /dev/null; then
        dunstify -u normal -t "$TIMEOUT" -i "audio-x-generic" -r 1000 "Player $selected_player not active"
        echo "Player $selected_player not active" >> "$DEBUG_LOG"
        selected_player=$(playerctl --list-all 2>/dev/null | head -n 1)
        if [ -z "$selected_player" ]; then
            echo "No active players, exiting" >> "$DEBUG_LOG"
            exit 0
        fi
        echo "$selected_player" > "$STATE_FILE"
        echo "Switched to new player: $selected_player" >> "$DEBUG_LOG"
    fi

    # Get player status (playing/paused)
    status=$(playerctl --player="$selected_player" status 2>/dev/null)
    if [ $? -ne 0 ]; then
        dunstify -u normal -t "$TIMEOUT" -i "audio-x-generic" -r 1000 "Player $selected_player not responding"
        echo "Player $selected_player not responding" >> "$DEBUG_LOG"
        exit 1
    fi
    echo "Status for $selected_player: $status" >> "$DEBUG_LOG"

    # Get metadata
    artist=$(playerctl --player="$selected_player" metadata artist 2>/dev/null)
    title=$(playerctl --player="$selected_player" metadata title 2>/dev/null)

    # Fallback if metadata is empty
    if [ -z "$artist" ] && [ -z "$title" ]; then
        media_info="Unknown Media"
    elif [ -z "$artist" ]; then
        media_info="$title"
    else
        media_info="$artist - $title"
    fi

    # Get player-specific icon
    icon=$(get_player_icon "$selected_player")

    # Send notification based on status
    case "$status" in
        "Playing")
            dunstify -u low -i "$icon" -t "$TIMEOUT" -r 1000 "Now Playing" "$media_info ($selected_player)"
            echo "Notified: Now Playing $media_info ($selected_player)" >> "$DEBUG_LOG"
            ;;
        "Paused")
            dunstify -u low -i "$icon" -t "$TIMEOUT" -r 1000 "Paused" "$media_info ($selected_player)"
            echo "Notified: Paused $media_info ($selected_player)" >> "$DEBUG_LOG"
            ;;
        *)
            dunstify -u normal -i "$icon" -t "$TIMEOUT" -r 1000 "Player $selected_player in unknown state"
            echo "Notified: Unknown state for $selected_player" >> "$DEBUG_LOG"
            ;;
    esac
}

# Monitor status changes for the selected player
while true; do
    # Read selected player
    if [ -f "$STATE_FILE" ]; then
        selected_player=$(cat "$STATE_FILE")
    else
        selected_player=$(playerctl --list-all 2>/dev/null | head -n 1)
        if [ -z "$selected_player" ]; then
            echo "No players available, sleeping" >> "$DEBUG_LOG"
            sleep 1
            continue
        fi
        echo "$selected_player" > "$STATE_FILE"
        echo "Set initial player: $selected_player" >> "$DEBUG_LOG"
    fi

    # Verify player is active
    if playerctl --list-all 2>/dev/null | grep -Fx "$selected_player" > /dev/null; then
        playerctl --player="$selected_player" -F status 2>/dev/null | while read -r line; do
            get_media_info
        done
    else
        echo "Player $selected_player not active, sleeping" >> "$DEBUG_LOG"
    fi
    sleep 1
done