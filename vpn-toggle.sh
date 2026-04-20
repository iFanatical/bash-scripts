#!/usr/bin/env bash

TUNNEL="tun1"

# Check if the tunnel interface is already up
if ip link show "$TUNNEL" &>/dev/null; then
    wg-quick down "$TUNNEL"
    dunstify -i network-offline -u normal "WireGuard" "Tunnel $TUNNEL is now DOWN"
else
    wg-quick up "$TUNNEL"
    dunstify -i network-vpn -u normal "WireGuard" "Tunnel $TUNNEL is now UP"
fi
