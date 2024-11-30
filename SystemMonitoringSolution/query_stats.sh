#!/bin/bash

print_usage() {
    echo "Usage: $0 --start 'YYYY-MM-DD HH:MM:SS' --end 'YYYY-MM-DD HH:MM:SS'"
    echo "Displays all stats between the start and end times."
}

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --start) start_date="$2"; shift ;;
        --end) end_date="$2"; shift ;;
        *) echo "Unknown parameter: $1"; print_usage; exit 1 ;;
    esac
    shift
done

# Validate inputs
if [[ -z "$start_date" || -z "$end_date" ]]; then
    echo "Both start and end dates must be specified"
    print_usage
    exit 1
fi

# Execute query
echo "Timestamp,CPU%,Memory%"
awk -F',' -v start="$start_date" -v end="$end_date" '
    $1 >= start && $1 <= end {
        printf "%s,%.2f,%.2f,\n", $1, $2, $3
    }
' /tmp/system_stats.log