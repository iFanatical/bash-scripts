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
DEBUG_LOG="/tmp/cycle_player_debug.log"

# Notification timeout in milliseconds (e.g., 3000 = 3 seconds)
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

# Get list of active players
players=($(playerctl --list-all 2>/dev/null))
echo "Players detected: ${players[*]}" >> "$DEBUG_LOG"
if [ ${#players[@]} -eq 0 ]; then
    dunstify -u normal -t "$TIMEOUT" -i "audio-x-generic" "No media players active"
    : > "$STATE_FILE"
    echo "No players active, cleared state file" >> "$DEBUG_LOG"
    exit 0
fi

# Read current player from state file, default to first player if not set
if [ -f "$STATE_FILE" ]; then
    current_player=$(cat "$STATE_FILE")
else
    current_player="${players[0]}"
fi
echo "Current player: $current_player" >> "$DEBUG_LOG"

# Find index of current player in the list, default to 0 if not found
current_index=0
for i in "${!players[@]}"; do
    if [ "${players[$i]}" = "$current_player" ]; then
        current_index=$i
        break
    fi
done
echo "Current index: $current_index" >> "$DEBUG_LOG"

# Calculate next index (cycle through players)
next_index=$(( (current_index + 1) % ${#players[@]} ))
selected_player="${players[$next_index]}"
echo "Selected player: $selected_player, Next index: $next_index" >> "$DEBUG_LOG"

# Save selected player name to state file
echo "$selected_player" > "$STATE_FILE"

# Verify state file was updated
if [ "$(cat "$STATE_FILE")" != "$selected_player" ]; then
    echo "Failed to update state file with $selected_player" >> "$DEBUG_LOG"
    dunstify -u critical -t "$TIMEOUT" -i "audio-x-generic" "Error updating player selection"
    exit 1
fi

# Get player-specific icon
icon=$(get_player_icon "$selected_player")

# Send notification for selected player
dunstify -u low -t "$TIMEOUT" -i "$icon" "Selected Player" "$selected_player"
echo "Notified: Selected Player $selected_player" >> "$DEBUG_LOG"