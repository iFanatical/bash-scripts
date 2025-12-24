#!/bin/bash
DAYS=$(uptime | awk -F, '{sub(".*up ",x,$1);print $1}' | cut -c 1)
HOURS=$(uptime | awk -F, '{sub(".*up ",x,$1);print $2}' | cut -c 2-3)
MINUTES=$(uptime | awk -F, '{sub(".*up ",x,$1);print $2}' | cut -c 5-6)

echo -e $DAYS days, $HOURS hours, $MINUTES minutes
