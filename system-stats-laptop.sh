#!/usr/bin/env bash

# sensors
cputemp=$(sensors | awk '/^CPU:/ {print $2}' | sed 's/+//;s/\..*$//')
memuse=$(free -m | awk '/^Mem/ {print ($3)/1000}' | cut -c-4)

echo -e  $cputemp"°C"  $memuse"GiB"

