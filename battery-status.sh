#!/usr/bin/env bash


get_battery_percent() {
    local BATTPER=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | awk '{print $2}' | sed 's/%//')
    local BATTSTATE=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/state/ {print $2}')
    if [ "$BATTSTATE" = "charging" ]; then
	echo "󰂅 $BATTPER%"
    else
	if [ "$BATTPER" -le 5 ]; then
	    echo "󰁺 $BATTPER%"
	elif [ "$BATTPER" -le 20 ]; then
	    echo "󰁻 $BATTPER%"
	elif [ "$BATTPER" -le 40 ]; then
	    echo "󰁽 $BATTPER%"
        elif [ "$BATTPER" -le 60 ]; then
	    echo "󰁿 $BATTPER%"
	elif [ "$BATTPER" -le 80 ]; then
	    echo "󰂁 $BATTPER%"
	elif [ "$BATTPER" -le 100 ]; then
	    echo "󰁹 $BATTPER%"
	fi
    fi
}

echo -e $(get_battery_percent) && exit 0
