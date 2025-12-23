#!/bin/bash

# Get the current active profile
current_profile=$(powerprofilesctl list | grep '*' | awk '{print $2}' | sed 's/://g')

case $current_profile in
    performance)
	dunstify -t 2000 -i system-suspend "Switching to balanced profile."
	powerprofilesctl set balanced
	exit 0
	;;
    balanced)
	dunstify -t 2000 -i system-suspend-hibernate "Switching to power-saving profile."
	powerprofilesctl set power-saver
	exit 0
	;;
    power-saver)
	dunstify -t 2000 -i system-reboot "Switching to performance profile."
	powerprofilesctl set performance
	exit 0
	;;
    *)
	dunstify -u critical "Error: Unknown or no active profile detected"
	exit 1
	;;
esac
