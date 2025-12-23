#!/usr/bin/env bash

dbus-update-activation-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &

gsettings set $gnome-schema gtk-theme fan-custom-theme &
gsettings set $gnome-schema icon-theme Tela-circle-nord &
gsettings set $gnome-schema cursor-theme breeze-dark &
gsettings set $gnome-schema font-name "Ubuntu Mono 10" &
gsettings set $gnome-schema cursor-size 24 &

/usr/bin/pipewire &
/usr/bin/pipewire-pulse &
/usr/bin/wireplumber &
/usr/lib/xdg-desktop-portal &
$SCRIPTS/media-notification.sh &

wlr-randr --output DP-2 --mode 1920x1080@100Hz --output DP-1 --mode 1920x1080@100Hz &
swww-daemon &
$SCRIPTS/gpu-screen-recorder.sh &
dunst &
xrandr --output DP-2 --primary &
/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
amixer -c 0 sset 'Mic' mute &

solaar --window hide &
blueman-applet &

brave &
rustdesk &
