#!/bin/bash

LOGFILE=${SYSTEM_STATSFILE:-/tmp/system_stats.log}

# Detect platform
if [[ $OSTYPE == "darwin"* ]]; then
	PLATFORM="mac"
else
	PLATFORM="linux"
fi

get_cpu_usage() {
	if [[ $PLATFORM == "mac" ]]; then
		top -l 1 -n 0 -F | grep -E "^CPU" | awk '{print $3+$5}'
	else
		top -b -n 1 | grep "Cpu(s)" | awk -F',' '{print $4}' | awk '{print 100-$1}'
	fi
}

get_mem_usage() {
	if [[ $PLATFORM == "mac" ]]; then
		top -l 1 -n 0 | grep "PhysMem" | awk '{print $2}' | sed 's/M//' | awk '{print ($1/4096)*100}'
	else
		free | grep Mem | awk '{print $3/$2 * 100.0}'
	fi
}

collect_mode() {
	timestamp=$(date "+%Y-%m-%d %H:%M:%S")
	cpu_usage=$(get_cpu_usage)
	mem_usage=$(get_mem_usage)
	echo "$timestamp,$cpu_usage,$mem_usage" >>"$LOGFILE"
}

display_stats() {
	clear
	echo "System Monitor Dashboard"
	echo "========================"

	cpu=$(get_cpu_usage)
	printf "CPU Usage: %5.1f%% " "$cpu"
	draw_bar ${cpu%.*}
	echo ""

	mem=$(get_mem_usage)
	printf "Memory Usage: %5.1f%% " "$mem"
	draw_bar ${mem%.*}
	echo ""

	echo "========================"
	echo "Press Ctrl+C to exit"
}

query_stats() {
	while [[ $# -gt 0 ]]; do
		case $1 in
		--start)
			start_date="$2"
			shift
			;;
		--end)
			end_date="$2"
			shift
			;;
		*)
			echo "Unknown parameter: $1"
			exit 1
			;;
		esac
		shift
	done

	if [[ -z $start_date || -z $end_date ]]; then
		echo "ERROR: Both start and end dates must be specified"
		exit 1
	fi

	if [[ ! -f $LOGFILE ]]; then
		echo "ERROR: Log file not found at $LOGFILE"
		exit 1
	fi

	echo "Timestamp,CPU%,Memory%"
	awk -F',' -v start="$start_date" -v end="$end_date" '
		$1 >= start && $1 <= end {
			printf "%s,%.2f,%.2f\n", $1, $2, $3
		}
	' "$LOGFILE"
}

draw_bar() {
	local percent=$1
	local bars=$((percent / 5))
	printf "["
	for ((i = 0; i < 20; i++)); do
		if ((i < bars)); then printf "#"; else printf " "; fi
	done
	printf "] "
}

while [[ $# -gt 0 ]]; do
	case "$1" in
	--c)
		echo "Collect mode"
		collect_mode
		;;
	--d)
		echo "Display mode"
		while true; do
			display_stats
			sleep 5
		done
		;;
	--q)
		echo "Query mode"
		shift
		query_stats "$@"
		exit
		;;
    --help)
        echo "See the assignment description for a help message"
        ;;
	*)
		echo "Usage: $0 [--c | --d | --q]"
		exit 1
		;;
	esac
	shift
done
