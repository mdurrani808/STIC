#!/bin/bash

# Help function
print_help() {
    echo "Usage: $0"
    echo "Collects system CPU and memory usage and logs to a file"
    echo
    echo "The log file location can be set using SYSTEM_STATSFILE environment variable"
    echo "Default location: /tmp/system_stats.log"
}
if [[ "$1" == "--help" ]]; then
    print_help
    exit 0
fi

get_cpu_usage() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        top -l 1 -n 0 -F | grep -E "^CPU" | awk '{print $3+$5}'
    else
        top -b -n 1 | grep "Cpu(s)" | awk -F',' '{print $4}' | awk '{print 100-$1}'
    fi
}
get_mem_usage() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        top -l 1 -n 0 | grep "PhysMem" | awk '{print $2}' | sed 's/M//' | awk '{print ($1/4096)*100}'
    else
        free | grep Mem | awk '{print $3/$2 * 100.0}'
    fi
}

# Determine log file location
LOGFILE=${SYSTEM_STATSFILE:-/tmp/system_stats.log}

# Collect and format data
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
cpu_usage=$(get_cpu_usage)
mem_usage=$(get_mem_usage)

# Append to log file
echo "$timestamp,$cpu_usage,$mem_usage" >> "$LOGFILE"