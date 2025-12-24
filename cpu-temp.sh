#!/usr/bin/env bash

echo "$(($(cat /sys/class/hwmon/hwmon6/temp1_input) / 1000))°C"
