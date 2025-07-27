#!/usr/bin/env bash

MICCHECK=$(amixer | awk '/^  Front Left.*Capture/ {print $6}' | sed 's/\[//;s/]//g')
ENABLED=""
DISABLED=""

if [ "$MICCHECK" = on ]; then
	echo $ENABLED;
	exit 0;
    else
	echo $DISABLED;
	exit 0;
fi
