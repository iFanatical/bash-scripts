#!/usr/bin/env bash

cputemp=$(sensors | awk '/^CPU:/ {print $2}' | sed 's/+//;s/\..*$//')
echo -e $cputemp"°C"
