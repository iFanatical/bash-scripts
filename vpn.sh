#!/usr/bin/env bash
TUNNEL="tun1"

case "$1" in
    --toggle)
	if ip link show "$TUNNEL" &>/dev/null; then
	    wg-quick down "$TUNNEL"
	    dunstify -i network-offline -u normal "WireGuard" "Tunnel $TUNNEL is now DOWN"
	else
	    wg-quick up "$TUNNEL"
	    dunstify -i network-vpn -u normal "WireGuard" "Tunnel $TUNNEL is now UP"
	fi
	;;
    --status)
	if ip link show "$TUNNEL" &>/dev/null; then
	    echo -e "^c#9ece6a^󰕥"
	else
	    echo -e "^c#f7768e^󰦞"
	fi
	;;
esac
