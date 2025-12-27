#!/usr/bin/env bash

get_uptime() {
    uptime_seconds=$(awk '{print int($1)}' /proc/uptime 2>/dev/null)
    
    days=$(( uptime_seconds / 86400 ))
    remaining_seconds=$(( uptime_seconds % 86400 ))
    hours=$(( remaining_seconds / 3600 ))
    remaining_seconds=$(( remaining_seconds % 3600 ))
    minutes=$(( remaining_seconds / 60 ))

    if [[ $days -eq 1 ]]; then
        days_part="1 day"
    else
        days_part="$days days"
    fi

    if [[ $hours -eq 1 ]]; then
        hours_part="1 hour"
    else
        hours_part="$hours hours"
    fi

    if [[ $minutes -eq 1 ]]; then
        minutes_part="1 minute"
    else
        minutes_part="$minutes minutes"
    fi

    parts=()
    [[ $days -gt 0 ]] && parts+=("$days_part,")
    [[ $hours -gt 0 ]] && parts+=("$hours_part,")
    [[ $minutes -gt 0 ]] && parts+=("$minutes_part")

    if [[ ${#parts[@]} -eq 0 ]]; then
        echo "Less than 1 minute"
    else
        echo "${parts[*]}"
    fi
}

get_uptime
