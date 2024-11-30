#!/bin/bash

display_stats() {
    clear
    echo "System Monitor Dashboard"
    echo "========================"
    
    # CPU Usage
    cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    printf "CPU Usage: %5.1f%% " $cpu
    draw_bar ${cpu%.*}  # Remove decimal part
    
    # Memory Usage
    mem=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    printf "Memory Usage: %5.1f%% " $mem
    draw_bar ${mem%.*}  # Remove decimal part
    
    
    echo "========================"
    echo "Press Ctrl+C to exit"
}

draw_bar() {
    local percent=$1
    local bars=$((percent / 5))
    printf "["
    for ((i=0; i<bars; i++)); do printf "#"; done
    for ((i=bars; i<20; i++)); do printf " "; done
    printf "] "
}

# Run the display_stats function every 5 seconds
while true; do
    display_stats
    sleep 5
done