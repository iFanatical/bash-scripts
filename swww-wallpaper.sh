#!/usr/bin/env bash
# Script name: swww-paper

set -euo pipefail

FMENU="fzf --layout=reverse \
           --exact \
           --border=bold \
           --border=sharp \
           --margin=5% \
           --color=dark \
           --height=95% \
           --info=hidden \
           --header-first \
           --bind change:top \
           --prompt"

picturefiles=()
for dir in $HOME/Pictures; do
  if [ -d "$dir" ]; then
    picturefiles+=("$(find "$dir" -type f -print)")
  fi
done

setpicture() {
    for i in "$@"; do
        tput setaf 9 bold
        printf "%s" "✗ "
        tput setaf 9 bold
        swww img "$i"
        printf "%s" "$(basename "$i")"
        tput sgr0
        printf "%s\n\n" " set as wallpaper."
    done
}

if [ $# -eq 0 ]; then
    selection=$($FMENU "Select one or more wallpapers! " < <(printf "%s\n" "${picturefiles[@]}"))
    if [[ -n "$selection" ]]; then
        setpicture $selection
        exit
    fi
fi