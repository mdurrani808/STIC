#!/bin/bash

print_usage() {
    echo "Usage: $0 --start 'YYYY-MM-DD HH:MM:SS' --end 'YYYY-MM-DD HH:MM:SS'"
    echo "Displays all stats between the start and end times."
}

if [[ "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --start) start_date="$2"; shift ;;
        --end) end_date="$2"; shift ;;
        *) echo "Unknown parameter: $1"; print_usage; exit 1 ;;
    esac
    shift
done
if [[ -z "$start_date" || -z "$end_date" ]]; then
    echo "ERROR: Both start and end dates must be specified"
    print_usage
    exit 1
fi

# Determine log file location
LOGFILE=${SYSTEM_STATSFILE:-/tmp/system_stats.log}

if [[ ! -f "$LOGFILE" ]]; then
    echo "ERROR: Log file not found at $LOGFILE"
    exit 1
fi

echo "Timestamp,CPU%,Memory%"
awk -F',' -v start="$start_date" -v end="$end_date" '
    $1 >= start && $1 <= end {
        printf "%s,%.2f,%.2f,\n", $1, $2, $3
    }
' "$LOGFILE"