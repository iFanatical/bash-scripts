#!/bin/bash

USEDMEM=$(free -m | awk '/^Mem/ {print ($3)/1024}' | cut -c-4)g
TOTALMEM=$(free -m | awk '/^Mem/ {print ($2)/1024}' | cut -c-4)g

echo " $USEDMEM / $TOTALMEM"
