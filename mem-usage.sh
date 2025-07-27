#!/bin/bash

USEDMEM=$(free | awk '/^Mem/ {print $3}')
TOTALMEM=$(free | awk '/^Mem/ {print $2}')

PERCENT=$(echo "($USEDMEM * 100) / $TOTALMEM" | bc)

echo "${PERCENT}%"
