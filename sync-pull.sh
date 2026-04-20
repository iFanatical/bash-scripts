#!/usr/bin/env bash
# sync-pull.sh
# Manually run this on any laptop to pull files down from /rsync/ on the sync server (10.1.10.3)

SERVER="10.1.10.3"
USER="$(whoami)"
REMOTE_BASE="/rsync"
LOG="$HOME/.local/share/sync-pull.log"
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

FOLDERS=(
    "$HOME/Documents"
    "$HOME/Pictures"
    "$HOME/projects"
    "$HOME/.config/alacritty"
    "$HOME/.config/dunst"
    "$HOME/.config/eza"
    "$HOME/.config/fastfetch"
    "$HOME/.config/gtk-3.0"
    "$HOME/.config/gtk-4.0"
    "$HOME/.config/hypr"
    "$HOME/.local/bin"
    "$HOME/.config/nvim"
    "$HOME/.config/picom"
    "$HOME/.config/qt5ct"
    "$HOME/.config/qt6ct"
    "$HOME/.config/rofi"
    "$HOME/source-files"
    "$HOME/.config/vlc"
    "$HOME/.config/waybar"
    "$HOME/.config/xsettingsd"
)

echo "[$TIMESTAMP] Starting pull sync from $SERVER:$REMOTE_BASE" >> "$LOG"

for FOLDER in "${FOLDERS[@]}"; do
    # Strip $HOME prefix to get relative path
    RELATIVE="${FOLDER/#$HOME\//}"
    REMOTE_PATH="$REMOTE_BASE/$RELATIVE"
    LOCAL_PARENT="$(dirname "$FOLDER")"

    # Create local parent directory if it doesn't exist
    mkdir -p "$LOCAL_PARENT"

    rsync -az --delete \
        -e "ssh -i $HOME/.ssh/id_ed25519 -o StrictHostKeyChecking=no" \
        "$USER@$SERVER:$REMOTE_PATH" \
        "$LOCAL_PARENT/" \
        >> "$LOG" 2>&1

    echo "[$TIMESTAMP] Pulled: $SERVER:$REMOTE_PATH -> $LOCAL_PARENT/" >> "$LOG"
done

echo "[$TIMESTAMP] Pull sync complete." >> "$LOG"

notify-send -a "Sync Pull" -t 0 "Sync Complete" "All folders have been pulled from $SERVER successfully."
