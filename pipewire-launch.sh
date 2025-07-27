#!/bin/bash

if [[ -f "/usr/bin/systemctl" ]]; then
	echo "systemd running..."
else
	/usr/bin/pipewire &
	/usr/bin/pipewire-pulse &
	/usr/bin/wireplumber &
fi
