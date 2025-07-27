#!/bin/bash

# theme settings
gsettings set $gnomeschema gtk-theme fan-custom-theme &
gsettings set $gnomeschema icon-theme Tela-circle-nord &
gsettings set $gnomeschema cursor-theme breeze-dark &
gsettings set $gnomeschema font-name Ubuntu Mono 10 &
gsettings set $gnomeschema cursor-size 24 &

# decorations
$SCRIPTS/picom-restart.sh
$HOME/.custom-exes/cmdemo-app/cmdemo_script DP-2 1.2 &
$HOME/.custom-exes/cmdemo-app/cmdemo_script DP-1 1.2 &

# tray
blueman-applet &
solaar --window hide &

# software
numlockx &
