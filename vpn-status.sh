#!/usr/bin/env bash

TUNNEL="tun1"

if ip link show "$TUNNEL" &>/dev/null; then
    echo -e "󰕥"
else
    echo -e "󰦞"
fi
