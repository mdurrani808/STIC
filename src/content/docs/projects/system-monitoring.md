---
title: System Monitoring Dashboard
description: System Monitoring Dashboard project for CMSC398W.
---

## Overview

In this project, you will create a basic system monitoring tool via a Bash script that runs in the terminal. The tool will display real-time system statistics and allow for simple historical data analysis. This project will help you practice shell scripting, data collection, and basic data analysis using common Unix tools.

## Description

You will write a Bash script that will support three "operating modes": collection, display, and query. Users will interact with your script in the following way:

```bash
./[script name].sh [operating mode flag] [additional options]
```

The table below details the possible operating mode flags and additional options.

| Flag     | Type           | Description                                                                  |
|----------|----------------|------------------------------------------------------------------------------|
| `-c`     | Operating Mode | Enables the `Collection` operating mode. Required.                           |
| `-d`     | Operating Mode | Enables the `Display` operating mode. Required.                              |
| `-q`     | Operating Mode | Enables the `Query` operating mode. Required.                                |
| `--start`| Configuration  | Sets the start datetime for a query. Required in the `Query` operating mode. |
| `--end`  | Configuration  | Sets the end datetime for a query. Required in the `Query` operating mode.   |
| `--help` | User Flag      | Prints out a message on how to use this script. Required.                    |

Sample code to parse the operating mode commands is provided, but it is up to you to integrate it into your script.

## Requirements

### 0. Overall Requirements

The script must:

- Be written as a Bash script
- Make use of variables, conditionals, loops, functions, variable substitutions, and other shell syntax as demonstrated in other parts of the course
- Be commented, and clearly written
- Implement the `--help` flag

### 1. Collection Mode

Collection mode must:

- Be enabled via the `-c` flag
- Collect CPU and memory usage (the amount of RAM currently being used by the system)
- Parse and format the data into a simple CSV format
- Append the collected data to a log file with a timestamp
- Use system utilities like `top` and `free` with appropriate command line flags to determine CPU/memory usage; capturing resources does not need to account for multiple CPUs as it is intended a system summary

:::note
`free` isn't available on macOS, so we recommend parsing the output of the `memory_pressure` command instead for memory usage. `free` should still work on WSL/Unix machines. For WSL/Unix systems, look at the row starting with `Mem`.
:::

- Store results in a CSV file determined by the environment variable `SYSTEM_STATSFILE`; if this variable is not present, use the default `/tmp/system_stats.log`
- Collection times can use any timestamp format, but using the output of `date` is recommended

Running your script in this mode:

```bash
./system_monitoring_tool.sh -c
```

Output format:

```
DATETIME1, CPU%, MEM%
DATETIME2, CPU%, MEM%
DATETIME3, CPU%, MEM%
...
```

Example contents of the default log file after several runs:

```
>> cat /tmp/system_stats.log
2025-01-08 15:43:12,3.0,55.5611
2025-01-08 15:43:32,84.4,55.3498
2025-01-08 15:43:33,84.5,55.4192
2025-01-08 16:00:15,80.6,57.004
2025-01-08 16:00:20,83.3,57.0953
```

### 2. Display Mode

Display mode must:

- Be enabled via the `-d` flag
- Display current CPU and memory usage as a percentage
- Update the display every 5 seconds using a loop that clears the terminal and redraws output
- Obtain CPU and Memory usage using standard tools as in collection mode
- Show a visual horizontal bar graph representation of usage

Suggested output:

```
>> ./system_monitoring_tool.sh -d
System Monitor Dashboard
========================
CPU Usage:     19.4% [###                 ]
Memory Usage:  57.7% [###########         ]
========================
Press Ctrl+C to exit
```

### 3. Query Mode

Query mode must:

- Be enabled via the `-q` flag
- Accept start and end date/time parameters via `--start` and `--end` flags
- Filter and display data from the log file within the specified time range
- Output results in a readable CSV format
- Honor the `SYSTEM_STATSFILE` variable or default to `/tmp/system_stats.log`
- Implement error detection when start/end dates are not specified

Sample output:

```
>> ./system_monitoring_tool.sh -q
ERROR: Both start and end dates must be specified
Usage: query_stats.sh --start 'YYYY-MM-DD HH:MM:SS' --end 'YYYY-MM-DD HH:MM:SS'
Displays all stats between the start and end times.

>> cat /tmp/system_stats.log
2025-01-08 15:43:12,3.0,55.5611
2025-01-08 15:43:32,84.4,55.3498
2025-01-08 15:43:33,84.5,55.4192
2025-01-08 16:00:15,80.6,57.004
2025-01-08 16:00:20,83.3,57.0953

>> ./system_monitoring_tool.sh -q --start '2025-01-08 15:43:12' --end '2025-01-08 15:43:33'
Timestamp,CPU%,Memory%
2025-01-08 15:43:12,3.00,55.56,
2025-01-08 15:43:32,84.40,55.35,
2025-01-08 15:43:33,84.50,55.42,
```

## Grading (60 pts)

### Script (40 pts)

- Clearly written and commented code (10 points)
- Meets specification for each mode (10 points per mode)

### Video (20 pts)

- Must be under 6 minutes (20% penalty if over)
- Screen recording showing:
  - Walk through the source code for each part and explain its functionality (10 points)
  - Run and demonstrate functionality based on the project specification (10 points)

### Submission Requirements

- Submit a single Bash script: `system_monitoring_tool.sh`
- Submit a video showing usage of your script
- Upload to the assignment on Gradescope

### Late Policy

10% deduction per day late.

## Sample Code

### Operating Mode Parsing

```bash
while [[ $# -gt 0 ]]; do
    case "$1" in
        -c)
            echo "Collect mode"
            ;;
        -d)
            echo "Display mode"
            ;;
        -q)
            echo "Query mode"
            ;;
        *)
            echo "Unknown parameter: $1"
            echo "Usage: $0 [-c | -d | -q]"
            exit 1
            ;;
    esac
    shift
done
```

For parsing `--start` and `--end`, you can use a similar loop with `$@`.

## Notes for WSL / VMs

WSL/VMs may show very low or zero CPU usage. This is normal and will not impact your grade. You may see:

```
%Cpu(s): 0.0 us, 0.0 sy, 0.0 ni,100.0 id, 0.0 wa, 0.0 hi, 0.0 si, 0.0 st
```

This is because WSL runs as a VM and only tracks its own usage.
