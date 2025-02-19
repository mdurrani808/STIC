# System Monitoring Dashboard Project

## Overview

In this project, you will create a basic system monitoring tool that runs in the terminal. The tool will display real-time system statistics and allow for simple historical data analysis. This project will help you practice shell scripting, data collection, and basic data analysis using common Unix tools.

## Requirements

### 0. Script Requirements

Each script must:

- Make use of variables, conditionals, loops, functions, variable substitutions, and other shell syntax as demonstrated in other parts of the course
- Be commented, and clearly written
- Implement the –help flag

### 1. Data Collection Script

Create a bash script named `collect_stats.sh` that:

- Collects CPU and memory usage
- Parse and format the data into a simple CSV format
- Appends the collected data to a log file with a timestamp
- Use system utilities like top and free with appropriate command line flags to determine CPU/memory usage; capturing resources does not need to account for multiple CPUs as it is intended a system summary
- Store the results in a CSV file that is determined by the environment variable SYSTEM_STATSFILE; if this variable is not present, use the default /tmp/system_stats.log  
- Collection times can use any timestamp format but it is suggested that the output of date be used as this is standard and widely available
- An example of the default contents of running the script several times accumulating the contents in the default output file looks like the following:

```console
>> cat /tmp/system_stats.log 
2025-01-08 15:43:12,3.0,55.5611
2025-01-08 15:43:32,84.4,55.3498
2025-01-08 15:43:33,84.5,55.4192
2025-01-08 16:00:15,80.6,57.004
2025-01-08 16:00:20,83.3,57.0953
```

### 2. Query Tool

Create a bash script named `query_stats.sh` that:

- Accepts start and end date/time parameters
- Filters and displays data from the log file within the specified time range
- Outputs the results in a readable CSV format
- Honors the SYSTEM_STATSFILE variable as with the collect_stats.sh script querying it or defaulting to  /tmp/system_stats.log  that variable is not set
- Implements –help flag
- Implement error  detection when the command line arguments do not specify start/end dates for the query
- It is strongly suggested that UNIX text processing tools be used to complete the required functionality; the instructor solution relies heavily on awk

Sample output is show below:

```console
# error cases for underspecifying the command line invocation
>> bash query_stats.sh
ERROR: Both start and end dates must be specified
Usage: query_stats.sh --start 'YYYY-MM-DD HH:MM:SS' --end 'YYYY-MM-DD HH:MM:SS'
Displays all stats between the start and end times.

>> bash query_stats.sh --start '2025-01-08 15:43:12'
ERROR: Both start and end dates must be specified
Usage: query_stats.sh --start 'YYYY-MM-DD HH:MM:SS' --end 'YYYY-MM-DD HH:MM:SS'
Displays all stats between the start and end times.

# contents of the log (default file)
>> cat /tmp/system_stats.log 
2025-01-08 15:43:12,3.0,55.5611
2025-01-08 15:43:32,84.4,55.3498
2025-01-08 15:43:33,84.5,55.4192
2025-01-08 16:00:15,80.6,57.004
2025-01-08 16:00:20,83.3,57.0953

# show a range of entries
>> bash query_stats.sh --start '2025-01-08 15:43:12' --end '2025-01-08 15:43:33'
Timestamp,CPU%,Memory%
2025-01-08 15:43:12,3.00,55.56,
2025-01-08 15:43:32,84.40,55.35,
2025-01-08 15:43:33,84.50,55.42,

# show a different range of entries
>> bash query_stats.sh --start '2025-01-08 15:43:15' --end '2025-01-08 16:16:00'
Timestamp,CPU%,Memory%
2025-01-08 15:43:32,84.40,55.35,
2025-01-08 15:43:33,84.50,55.42,
2025-01-08 16:00:15,80.60,57.00,
2025-01-08 16:00:20,83.30,57.10,
```

### 3. Real-time Display Script

Create a bash script named `display_stats.sh` that:

- Displays current CPU and memory usage as a percentage
- Updates the display every 5 seconds using a loop which clears the terminal display and redraws output and the shell builtin sleep command
- Obtain CPU and Memory usage using standard tools as was done in a previous script
- Show a visual representation of the usage as a horizontal “bar” graph and lines output up attractively

Suggested output is shown below:

```console
>> bash display_stats.sh
System Monitor Dashboard
========================
CPU Usage:     19.4% [###                 ]
Memory Usage:  57.7% [###########         ] 
========================
Press Ctrl+C to exit
```

## Grading Criteria

### Script (30pts)

- Clearly written, and commented code (5 points per script)
- Meets specification laid out in the requirements section. (5 points per script)

### Video (30 pts)

- Video must be under 5 minutes (20% penalty).
- Screen recording showing the following:
  - Go through the source code for each script and explain the functionality. (5 points per script)
  - Run and display the functionality of each script based on the project specification  (5 points per script)

### Submission Requirements

- Submit three bash scripts: `collect_stats.sh`, `display_stats.sh`, and `query_stats.sh`
- Submit a video showing the usage of your scripts.
- Upload the required video and files to the assignment listed on Gradescope.

### Late Policy

- 10% deduction per day late
