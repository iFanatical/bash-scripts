#!/usr/bin/env bash
TUNNEL="tun1"

source "$SCRIPTS/bar-colors.sh"
source "$SCRIPTS/bar-refresh.sh"

case "$1" in
    --toggle)
        if ip link show "$TUNNEL" &>/dev/null; then
            wg-quick down "$TUNNEL"
            dunstify -i network-offline -u normal "WireGuard" "Tunnel $TUNNEL is now DOWN"
        else
            wg-quick up "$TUNNEL"
            if ip link show "$TUNNEL" &>/dev/null; then
                dunstify -i network-vpn -u normal "WireGuard" "Tunnel $TUNNEL is now UP"
            else
                dunstify -i network-vpn -u normal "WireGuard" "Tunnel $TUNNEL does not exist"
            fi
        fi
        refresh_bar 37 vpn
        ;;
    --status)
        if ip link show "$TUNNEL" &>/dev/null; then
            echo "$(bar_color '#9ece6a' '󰕥')"
        else
            echo "$(bar_color '#f7768e' '󰦞')"
        fi
        ;;
esac
