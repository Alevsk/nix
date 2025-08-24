#!/bin/bash

case "$1" in
    "cpu")
        # Simple CPU load average (1 min)
        uptime | awk '{print $10}' | sed 's/,//' | awk '{printf "%.0f", $1*100}'
        echo "%"
        ;;
    "mem")
        # Memory usage via activity monitor
        echo "$(ps -caxm -orss= | awk '{sum+=$1} END {printf "%.0f", sum/1024/1024*100/16}')%"
        ;;
    "bat")
        # Battery percentage
        pmset -g batt | grep -o '[0-9]*%' | head -1
        ;;
    *)
        echo "Usage: $0 {cpu|mem|bat}"
        ;;
esac
