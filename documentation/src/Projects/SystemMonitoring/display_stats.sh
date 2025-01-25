#!/bin/bash

get_cpu_usage() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        top -l 2 -n 0 -F | grep -E "^CPU" | tail -1 | awk '{print $3+$5}'
    else
        top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}'
    fi
}

get_memory_usage() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        top -l 1 -n 0 | grep "PhysMem" | awk '{print $2}' | sed 's/M//' | awk '{print ($1/4096)*100}'
    else
        free | grep Mem | awk '{print $3/$2 * 100.0}'
    fi
}

display_stats() {
    clear
    echo "System Monitor Dashboard"
    echo "========================"
    
    # CPU Usage
    cpu=$(get_cpu_usage)
    printf "CPU Usage: %5.1f%% " $cpu
    draw_bar ${cpu%.*}
    echo ""
    
    # Memory Usage
    mem=$(get_memory_usage)
    printf "Memory Usage: %5.1f%% " $mem
    draw_bar ${mem%.*}
    echo ""
    
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