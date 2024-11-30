#!/bin/bash

# Function to get CPU usage
get_cpu_usage() {
    top -b -n 1 | grep "Cpu(s)" | awk -F',' '{print $4}' | awk '{print $1}'
}

# Function to get memory usage
get_mem_usage() {
    free | grep Mem | awk '{print $3/$2 * 100.0}'
}

# Collect and format data
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
cpu_usage=$(get_cpu_usage)
mem_usage=$(get_mem_usage)

#2024-11-29 18:26:34

# Append to log file
echo "$timestamp,$cpu_usage,$mem_usage" >> /tmp/system_stats.log