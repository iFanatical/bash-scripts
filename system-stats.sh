#!/usr/bin/env bash
memuse=$(free -m | awk '/^Mem/ {print ($3)/1000}' | cut -c-4)
echo -e "^c#acb0d0^ $memuse GiB"
