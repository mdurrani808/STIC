Have you ever wanted to take data in one format and turn it into a different format? Of course you have! That, in very general terms, is what this lecture is all about. Specifically, massaging data, whether in text or binary format, until you end up with exactly what you wanted.

We've already seen some basic data wrangling in past lectures. Pretty much any time you use the `|` operator, you are performing some kind of data wrangling. Consider a command like `journalctl | grep -i intel`. It finds all system log entries that mention Intel (case insensitive). You may not think of it as wrangling data, but it is going from one format (your entire system log) to a format that is more useful to you (just the intel log entries). Most data wrangling is about knowing what tools you have at your disposal, and how to combine them.
## Regular Expression Refresher

### Basic Characters
Most letters and numbers in a regex pattern match themselves exactly. For example, the pattern `cat` matches the word "cat".
### Special Characters
`.` - Matches any single character except newline
`^` - Matches the start of a line
`$` - Matches the end of a line
`*` - Matches zero or more occurrences of the previous character
`+` - Matches one or more occurrences of the previous character
`?` - Makes the previous character optional
`\` - Escapes special characters (use `\.` to match an actual period)

### Character Classes
Square brackets let us define sets of characters to match:
`[abc]` - Matches any single character from the set (a, b, or c)
`[^abc]` - Matches any character except those in the set
`[a-z]` - Matches any lowercase letter
`[A-Z]` - Matches any uppercase letter
`[0-9]` - Matches any digit

### Common Shortcuts
Some frequently-used patterns have their own shortcuts:
`\d` - Matches any digit (equivalent to [0-9])
`\w` - Matches any word character (letters, digits, underscore)
`\s` - Matches any whitespace (space, tab, newline)
`\D`, `\W`, `\S` - Match anything except digits, word chars, and whitespace respectively
## Common Quantifiers

When you need to specify how many times something should match:

`{n}` - Exactly n times
`{n,}` - At least n times
`{n,m}` - Between n and m times
`*` - Zero or more times (equivalent to {0,})
`+` - One or more times (equivalent to {1,})
`?` - Zero or one time (equivalent to {0,1})
## Examples
### Validating an Email Address
```regex
^[\w\.-]+@[\w\.-]+\.\w+$
```
This pattern breaks down into:
- Start of line (`^`)
- One or more word characters, dots, or hyphens (`[\w\.-]+`)
- An @ symbol (`@`)
- More word characters, dots, or hyphens (`[\w\.-]+`)
- A dot (`\.`)
- One or more word characters (`\w+`)
- End of line (`$`)
### Matching a Phone Number
```regex
^\(\d{3}\)\s?\d{3}-\d{4}$
```
This matches phone numbers like (123) 456-7890:
- Start with parentheses and three digits (`^\(\d{3}\)`)
- Optional space (`\s?`)
- Three digits (`\d{3}`)
- Hyphen (`-`)
- Four digits (`\d{4}`)
## Data Wrangling and sed

The stream editor, commonly known as sed, is one of the most powerful text processing tools available in Unix-like operating systems. Created by Lee E. McMahon at Bell Labs in 1974, sed was designed as a successor to the revolutionary ed editor, bringing automation to text editing tasks. Think of sed as a text transformation pipeline - it reads input line by line, applies specified operations, and outputs the result.

Sed processes input line by line, applying commands to each line sequentially. It has two buffers, called the pattern space and the hold space. The pattern buffer is a temporary buffer, the scratchpad where the current information is stored. The hold buffer is for long term storage. There is also an address range, that specifies which lines the command should operate on. 

### Basic Command structure
The syntax of a sed command is:
```bash
sed [options] 'command' filename
```
Common options include:

- `-e`: Allows multiple commands
- `-i`: Edit files in-place
- `-n`: Suppress automatic printing of pattern space
- `-f`: Read commands from a file
### Essential Commands 
#### Substitution Command (s)
The substitution command is the most frequently used sed command. Its basic syntax is:
```bash
sed 's/pattern/replacement/flags'
```

Flags:
- `g`: Global replacement (replace all occurrences)
- `p`: Print the modified line
- `I`: Case-insensitive matching
- `w file`: Write the result to a file
Example:
```bash
# Replace first occurrence of 'dog' with 'cat'
sed 's/dog/cat/' file.txt

# Replace all occurrences of 'dog' with 'cat'
sed 's/dog/cat/g' file.txt
```
### Delete Command (d)
Removes lines matching a pattern:
```bash
# Delete lines containing 'pattern'
sed '/pattern/d' file.txt

# Delete lines 3 through 5
sed '3,5d' file.txt
```

### Print Command (p)

Prints specific lines:

```bash
# Print lines containing 'pattern'
sed -n '/pattern/p' file.txt
```

### Append (a) and Insert (i) Commands

Add text after or before matching lines:

```bash
# Append 'New Line' after each line containing 'pattern'
sed '/pattern/a\New Line' file.txt

# Insert 'New Line' before each line containing 'pattern'
sed '/pattern/i\New Line' file.txt
```

## Practical Examples

### Example 1: Converting File Formats
Convert Windows line endings to Unix:
```bash
sed 's/\r$//' file.txt
```

### Example 2: Numbering Lines
Add line numbers to a file:
```bash
sed = file.txt | sed 'N;s/\n/. /'
```

### Example 3: XML/HTML Processing
Remove HTML tags:
```bash
sed 's/<[^>]*>//g' file.html
```
## AWK: Text Processing Made Simple
AWK is a specialized programming language designed for processing text data. Created by Aho, Weinberger, and Kernighan (whose initials form its name), AWK shines when working with data organized in rows and columns, such as CSV files, log files, or any structured text data.

### AWK Sytnax

At its core, AWK processes text line by line using pattern-action pairs:
```awk
pattern { action }
```

Think of this as telling AWK "when you see this pattern, perform this action." If you omit the pattern, the action applies to every line. If you omit the action, AWK prints the matching lines.

AWK automatically splits each line into fields, which you can reference using dollar signs:
- `$0` refers to the entire line
- `$1` refers to the first field
- `$2` refers to the second field
And so on. By default, fields are separated by whitespace, but you can change this using the -F option.

### Essential Variables You'll Use Often

AWK provides several built-in variables that make text processing easier:
```awk
NR    # Keeps track of the current line number
NF    # Tells you how many fields are in the current line
FS    # The field separator (default is whitespace)
OFS   # The output field separator (what to put between fields when printing)
```

### Real-World Examples Explained

Let's look at some common text processing tasks and how AWK handles them:

1. Calculating Column Sums:
```awk
# Sum all values in the third column
awk '{ sum += $3 } END { print sum }' data.txt
```
This script does something simple but powerful. For each line, it adds the value from the third column (`$3`) to a running total (`sum`). The `END` block runs after all lines are processed, printing the final total. This is perfect for tasks like summing a column of numbers in a spreadsheet or calculating total bytes in a log file.

2. Processing CSV Data:
```awk
# Print records where the amount exceeds 1000
awk -F',' '$3 > 1000 { print $1, $3 }' sales.csv
```
Here we're doing several things at once:
- `-F','` tells AWK to use commas as field separators instead of spaces
- `$3 > 1000` is our pattern, matching lines where the third field exceeds 1000
- `print $1, $3` prints the first and third fields of matching lines
This is useful for tasks like finding high-value transactions in sales data or filtering large CSV files.

3. Log File Analysis:
```awk
# Count occurrences of HTTP status codes
awk '{ codes[$9]++ } 
     END { for(code in codes) print code, codes[code] }' access.log
```
This script demonstrates AWK's ability to handle associative arrays:
- `codes[$9]++` uses the ninth field (typically the HTTP status code in access logs) as an array index and counts occurrences
- The END block loops through all unique codes and prints their counts
This is invaluable for analyzing web server logs or any data where you need to count occurrences of values.

4. Data Transformation:
```awk
# Convert space-separated data to CSV format
awk '{ name=$1; salary=$2; print name "," salary }' employees.txt
```
This script shows how AWK can transform data formats:
- It takes the first two fields from each line
- Stores them in variables for clarity
- Prints them with a comma between them
This is useful when you need to convert data between different formats or extract specific fields from a larger dataset.

### Control Structures for Complex Processing

AWK supports familiar programming constructs for more complex tasks:
```awk
# Example of control structures
if ($3 > 1000) { 
    total += $3 
}

for (i=1; i<=NF; i++) { 
    sum += $i 
}

while (getline > 0) { 
    count++ 
}
```

## xargs: Making Command Lines More Powerful

xargs is a utility that bridges the gap between commands that produce output and commands that expect arguments. It's particularly useful when you need to process many files or handle command line limitations.
### syntax
The basic xargs syntax is:
```bash
xargs [OPTIONS] [COMMAND]
```
### Basic Usage Explained

Here's how xargs can help with common tasks:

1. Finding and Processing Files:
```bash
# Find and remove all temporary files
find . -name "*.tmp" | xargs rm
```
This command pipeline:
- `find` locates all files ending in .tmp
- `xargs` takes those filenames and passes them as arguments to `rm`
This is more efficient than using rm directly with find's -exec option.

2. Parallel Processing:
```bash
# Compress files in parallel
find . -type f | xargs -P 4 gzip
```
The `-P 4` option tells xargs to run up to 4 gzip processes simultaneously, significantly speeding up processing on multi-core systems.

3. Handling Special Characters:
```bash
# Safely handle filenames with spaces
find . -type f -print0 | xargs -0 file
```
The `-print0` and `-0` options work together to handle filenames containing spaces, newlines, or other special characters safely.

### Practical Applications

Let's look at some real-world uses:

1. Batch Processing:
```bash
# Convert images in groups of three
ls *.jpg | xargs -n 3 convert -resize 800x600
```
This processes files in batches of three, which can be useful when dealing with memory-intensive operations.

2. Custom Commands:
```bash
# Rename log files with .old extension
find . -name "*.log" | xargs -I {} mv {} {}.old
```
The `-I {}` option lets you specify where in the command to place each input item, giving you more flexibility in how you use the input.
