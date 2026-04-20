#!/usr/bin/env bash
# sync-push.sh
# Pushes specified folders from this machine to /rsync/ on the sync server (10.1.10.3)
# Runs every 30 minutes via cron

SERVER="10.1.10.3"
USER="$(whoami)"
REMOTE_BASE="/rsync"
LOG="$HOME/.local/share/sync-push.log"
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

echo "[$TIMESTAMP] Starting push sync to $SERVER:$REMOTE_BASE" >> "$LOG"

for FOLDER in "${FOLDERS[@]}"; do
    if [ -e "$FOLDER" ]; then
        # Strip $HOME prefix to get relative path, append to remote base
        RELATIVE="${FOLDER/#$HOME\//}"
        REMOTE_DIR="$REMOTE_BASE/$(dirname "$RELATIVE")"

        rsync -az --delete \
            -e "ssh -i $HOME/.ssh/id_ed25519 -o StrictHostKeyChecking=no" \
            "$FOLDER" \
            "$USER@$SERVER:$REMOTE_DIR/" \
            >> "$LOG" 2>&1

        echo "[$TIMESTAMP] Synced: $FOLDER -> $SERVER:$REMOTE_DIR/" >> "$LOG"
    else
        echo "[$TIMESTAMP] Skipped (not found): $FOLDER" >> "$LOG"
    fi
done

echo "[$TIMESTAMP] Push sync complete." >> "$LOG"
