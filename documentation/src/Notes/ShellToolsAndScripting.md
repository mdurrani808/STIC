# Shell Scripting and Shell Tools

## Shell Scripting

In this lecture, we will present some of the basics of using bash as a scripting language along with a number of shell tools that cover several of the most common tasks that you will be constantly performing in the command line.

So far we have seen how to execute commands in the shell and pipe them together. However, in many scenarios you will want to perform a series of commands and make use of control flow expressions like conditionals or loops.

Shell scripts are the next step in complexity. Most shells have their own scripting language with variables, control flow and its own syntax. What makes shell scripting different from other scripting programming languages is that it is optimized for performing shell-related tasks. Thus, creating command pipelines, saving results into files, and reading from standard input are primitives in shell scripting, which makes it easier to use than general purpose scripting languages. For this section we will focus on bash scripting since it is the most common.

### Creating a Basic Script

Start by creating a script file using any text editor, here we will create `myscript.sh`.

```bash
#!/bin/bash

echo "Hello world!"
```

The first line, called a *shebang* (`#!/bin/bash`), tells the system to use bash to execute this script. For better portability, use `#!/usr/bin/env bash`, which locates bash using the system's PATH variable. The second line executes the echo program with an argument of "Hello world!".

```admonish info
The *shebang* mentioned earlier is short of "Shell Bang" as the `!` mark is historically referred to as a "bang" in computing circles.  The first line of scripts will have this syntax though `bash` may be replaced by other script interpreters depending on the programming language used int the script. Some common examples are

| Shebang               | Interpreter / Language           |
|-----------------------|----------------------------------|
| `#!/bin/bash`         | Bash shell script                |
| `#!/bin/sh`           | Traditional vanilla shell script |
| `#!/usr/bin/python`   | Python script                    |
| `#!/usr/bin/awk -f`   | AWK script                       |
```

Now, make the script executable and run it.

```bash
chmod +x myscript.sh
./myscript.sh 
```

Here, we are adding execute permission for all to the myscript.sh file and then execute it. You should see "Hello world!" in your stdout.

Commands will often produce output using Standard Output (`STDOUT`, defaults to the screen), errors through Standard Error (`STDERR`, defaults to the screen), accept input through Standard Input (`STDIN`, defaults to typed input), and a Return Code (also called Exit Code) to report errors in a more script-friendly manner.  The return code is the way scripts/commands communicate the success or failure of their execution. A value of 0 usually means everything went OK; anything different from 0 means an error occurred. Commands can also be separated within the same line using a semicolon `;`.

### Assigning Variables

To assign variables in bash, use the syntax `foo=bar` and access the value of the variable with `$foo` or `${foo}`. Note that `foo = bar` will not work since it is interpreted as calling the `foo` program with arguments `=` and `bar`. In general, in shell scripts, the space character will perform argument splitting. This behavior can be confusing to use at first, so always check for that. All variables in bash will have global scope by default (unless noted otherwise).

Strings in bash can be defined with `'` and `"` delimiters, but they are not equivalent. Strings delimited with `'` are string literals and will not substitute variable values whereas `"` delimited strings will.

```bash
foo=bar
echo "$foo"
# prints bar
echo '$foo'
# prints $foo
```

Unlike other scripting languages, bash uses a variety of special variables to refer to arguments, error codes, and other relevant variables. Below is a list of some of them. A more comprehensive list can be found [here](https://tldp.org/LDP/abs/html/special-chars.html).

- `$0` - Name of the script
- `$1` to `$9` - Arguments to the script. `$1` is the first argument and so on.
- `$@` - All the arguments
- `$#` - Number of arguments
- `$?` - Return code of the previous command
- `$$` - Process identification number (PID) for the current script
- `!!` - Entire last command, including arguments. A common pattern is to execute a command only for it to fail due to missing permissions; you can quickly re-execute the command with sudo by doing `sudo !!`
- `$_` - Last argument from the last command. If you are in an interactive shell, you can also quickly get this value by typing `Esc` followed by `.` or `Alt+.`

### Control Flow

#### `if` / `else` statements

Basic if statement syntax:

```bash
if [[ condition ]]; then
    echo "Condition is true"
elif [[ another_condition ]]; then
    echo "Second condition is true"
else
    echo "No conditions were true"
fi
```

Common conditional tests:

- `-e file`: File exists
- `-d file`: Directory exists
- `-f file`: Regular file exists
- `-z string`: String is empty
- `-n string`: String is not empty
- `str1 = str2`: Strings are equal
- `n1 -eq n2`: Numbers are equal
- `n1 -lt n2`: Less than
- `n1 -gt n2`: Greater than
- `if ! [[ expr ]]; then`: Executes the expression and then negates the result
- `if [[ ! expr ]]; then`: Negates the individual expression

Exit codes can be used to conditionally execute commands using `&&` (and operator) and `||` (or operator), both of which are [short-circuiting](https://en.wikipedia.org/wiki/Short-circuit_evaluation) operators. The `true` program will always have a 0 return code and the `false` command will always have a 1 return code.

```admonish info
Both the following syntaxes will be honored for conditions in BASH scripts:
1. `if [ condition ]; then ...; fi`  : Historical
2. `if [[ condition ]]; then ...; fi` : Modern
The difference is age: the first which uses a single pair of `[ ]` is the original shell syntax and uses a subshell (starts another program) to evaluate the `condition`. This gets the job done but is computationally costly for its need to start a new shell. Newer shells including BASH offer the double pair `[[ ]]` operator which evaluates a condition within the running shell.  Favor the Modern version in all code that you write unless you expect it will be run on an ancient computing platform.
```

#### For loops

```bash
# Iterate over a list
for name in Alice Bob Charlie; do
    echo "Hello, $name"
done

# Iterate over files
for file in *.txt; do
    echo "Processing $file"
done

# C-style for loop
for ((i=0; i<5; i++)); do
    echo "Count: $i"
done

# counting loop via the seq command
for i in $(seq 0 5 30); do 
    echo i is $i; 
done
```

#### While loops

```bash
# Basic while loop using builtin [[ ]] and -lt comparison
count=0
while [[ $count -lt 5 ]]; do
    echo "Count: $count"
    ((count++))
done

# Use more standard arithmetic comparison via (( expr ))
count=0
while (( $count < 5 )); do
    echo "Count: $count"
    ((count++))
done

# Read file line by line
while read -r line; do
    echo "Line: $line"
done < input.txt

# iterating through command line flags
while [[ $# -gt 0 ]]; do
    if [[ $1 = "--help" ]]; then
        echo "you asked for help"
    shift
done
```

As the last example indicates, loop syntax can use I/O redirection and pipes via the `< > |` shell operators.

### Functions

Functions make your code more modular and reusable. Note that the function definition must be placed before any calls to the function. Local variables can be declared within the function definition using the `local` modifier (and can only be used in that function, as they have local scope). Unlike functions you see in other programming languages, Bash functions can't to return a value when called. When a bash function completes, its return value is the status of the last statement executed in the function, 0 for success and non-zero decimal number between 1 - 255 range for failure.

```bash
# Function definition
check_file() {
    local filename="$1"  # First argument
    if [[ -f "$filename" ]]; then
        echo "File exists"
        return 0
    else
        echo "File not found"
        return 1
    fi
}

# Function usage
check_file "example.txt" 
echo Function returned $?
```

Note several features

- Functions in shell scripts do not declare a parameter list making their prototypes less informative than in modern programming languages.
- The argument to the function is obtained via the `$1` automatic variable; functions called with several arguments will have `$2` and so on populated and the `$#` variable indicates how many arguments were passed.
- The final `echo` command shows the return value of the function using the built-in `$?` mentioned earlier which contains the last return code from a function or child process.

To return a non-integer value from a function, we have a few options. The simplest option is to assign the result of the function to a global variable:

```bash
#!/bin/bash

func () {
  toRet="my result"
}

func
echo $toRet
```

Alternatively, we can send our return value to stdout using `echo` or similar and use *command substitution* to get the output.Whenever you place `$( CMD )` it will execute `CMD`, get the output of the command and substitute it in place.

```bash
#!/bin/bash

func () {
  local toRet="my result"
  echo "$toRet"
}

func_result="$(func)"
echo $func_result
```

Since that was a huge information dump, let's see an example that showcases some of these features. It will iterate through the arguments we provide, `grep` for the string `foobar`, and append it to the file as a comment if it's not found.

```bash
#!/bin/bash

echo "Starting program at $(date)" # Date will be substituted

echo "Running program $0 with $# arguments with pid $$"

for file in "$@"; do
    grep foobar "$file" > /dev/null 2> /dev/null
    # When pattern is not found, grep has exit status 1
    # We redirect STDOUT and STDERR to a null register since we do not care about them
    if [[ $? -ne 0 ]]; then
        echo "File $file does not have any foobar, adding one"
        echo "# foobar" >> "$file"
    fi
done
```

### Shell Globs and Script Arguments

When launching scripts, you will often want to provide arguments that are similar. Bash has ways of making this easier, expanding expressions by carrying out filename expansion. These techniques are often referred to as shell *globbing*.

- Wildcards - Whenever you want to perform some sort of wildcard matching, you can use `?` and `*` to match one or any amount of characters respectively. For instance, given files `foo`, `foo1`, `foo2`, `foo10` and `bar`, the command `rm foo?` will delete `foo1` and `foo2` whereas `rm foo*` will delete all but `bar`.
- Curly braces `{}` - Whenever you have a common substring in a series of commands, you can use curly braces for bash to expand this automatically. This comes in very handy when moving or converting files.

```bash
convert image.{png,jpg}
# Will expand to
convert image.png image.jpg

cp /path/to/project/{foo,bar,baz}.sh /newpath
# Will expand to
cp /path/to/project/foo.sh /path/to/project/bar.sh /path/to/project/baz.sh /newpath

# Globbing techniques can also be combined
mv *{.py,.sh} folder
# Will move all *.py and *.sh files


mkdir foo bar
# This creates files foo/a, foo/b, ... foo/h, bar/a, bar/b, ... bar/h
touch {foo,bar}/{a..h}
touch foo/x bar/y
# Show differences between files in foo and bar
diff <(ls foo) <(ls bar)
# Outputs
# < x
# ---
# > y
```

```admonish info
Shell Globs and Regular Expressions are related but distinct methods to specify a pattern to be matched. Globs are tailored best to easily do the most common types of file name matching like all `*.txt` files (all text files). Regular expressions allow finer-grained control over matching at the expense being somewhat longer to specify.  Some programming libraries allow you to specify use of whichever is more convenient such as Python which has a [glob](https://docs.python.org/3/library/glob.html) library for file matching and a regular expression library in [re](https://docs.python.org/3/library/re.html).
```

### Shell Check

Writing `bash` scripts can be tricky and unintuitive. There are tools like [shellcheck](https://github.com/koalaman/shellcheck) that will help you find errors in your sh/bash scripts.

### Additional Built-in Syntax

Most shells have additional built-in commands and capabilities that they recognize like `cd / if / for / (( expr ))` and so on.  Bash will reveal a summary of its syntactic features by typing `help` with `help CMD` giving more information on the specific command. It is best to do some online reading to look for examples of the builtins as they can be tricky to use effectively.

```console
>> help bash
...
 job_spec [&]                                  history [-c] [-d offset] [n] or history -a>
 (( expression ))                              if COMMANDS; then COMMANDS; [ elif COMMAND>
 . filename [arguments]                        jobs [-lnprs] [jobspec ...] or jobs -x com>
 :                                             kill [-s sigspec | -n signum | -sigspec] p>
 [ arg... ]                                    let arg [arg ...]
 [[ expression ]]                              local [option] name[=value] ...
 alias [-p] [name[=value] ... ]                logout [n]
 bg [job_spec ...]                             mapfile [-d delim] [-n count] [-O origin] >
 bind [-lpsvPSVX] [-m keymap] [-f filename] >  popd [-n] [+N | -N]
 break [n]                                     printf [-v var] format [arguments]
 builtin [shell-builtin [arg ...]]             pushd [-n] [+N | -N | dir]
 caller [expr]                                 pwd [-LP]
 case WORD in [PATTERN [| PATTERN]...) COMMA>  read [-ers] [-a array] [-d delim] [-i text>
 cd [-L|[-P [-e]] [-@]] [dir]                  readarray [-d delim] [-n count] [-O origin>
 command [-pVv] command [arg ...]              readonly [-aAf] [name[=value] ...] or read>
 compgen [-abcdefgjksuv] [-o option] [-A act>  return [n]
 complete [-abcdefgjksuv] [-pr] [-DEI] [-o o>  select NAME [in WORDS ... ;] do COMMANDS; >
 compopt [-o|+o option] [-DEI] [name ...]      set [-abefhkmnptuvxBCEHPT] [-o option-name>
 continue [n]                                  shift [n]
 coproc [NAME] command [redirections]          shopt [-pqsu] [-o] [optname ...]
 declare [-aAfFgiIlnrtux] [name[=value] ...]>  source filename [arguments]
 dirs [-clpv] [+N] [-N]                        suspend [-f]
 disown [-h] [-ar] [jobspec ... | pid ...]     test [expr]
 echo [-neE] [arg ...]                         time [-p] pipeline
 enable [-a] [-dnps] [-f filename] [name ...>  times
 eval [arg ...]                                trap [-lp] [[arg] signal_spec ...]
 exec [-cl] [-a name] [command [argument ...>  true
 exit [n]                                      type [-afptP] name [name ...]
 export [-fn] [name[=value] ...] or export ->  typeset [-aAfFgiIlnrtux] name[=value] ... >
 false                                         ulimit [-SHabcdefiklmnpqrstuvxPRT] [limit]
 fc [-e ename] [-lnr] [first] [last] or fc ->  umask [-p] [-S] [mode]
 fg [job_spec]                                 unalias [-a] name [name ...]
 for NAME [in WORDS ... ] ; do COMMANDS; don>  unset [-f] [-v] [-n] [name ...]
 for (( exp1; exp2; exp3 )); do COMMANDS; do>  until COMMANDS; do COMMANDS-2; done
 function name { COMMANDS ; } or name () { C>  variables - Names and meanings of some she>
 getopts optstring name [arg ...]              wait [-fn] [-p var] [id ...]
 hash [-lr] [-p pathname] [-dt] [name ...]     while COMMANDS; do COMMANDS-2; done
 help [-dms] [pattern ...]                     { COMMANDS ; }

>> help read
read: read [-ers] [-a array] [-d delim] [-i text] [-n nchars] [-N nchars] [-p prompt] [-t timeout] [-u fd] [name ...]
    Read a line from the standard input and split it into fields.
    
    Reads a single line from the standard input, or from file descriptor FD
    if the -u option is supplied.  The line is split into fields as with word
...
```

### Limitations of Shell Scripts

As seen, the Programming Language understood by BASH and other shells has many of the features of other programming languages though the syntax for them is archaic.  One can accomplish a lot with shell scripts ([example 1](https://github.com/kauffman77/testy/blob/master/testyb), [example 2](https://github.com/gcc-mirror/gcc/blob/master/configure)).  That should not encourage you attempt such monoliths regularly: the Shell Programming language lacks adequate abstraction mechanisms to scale up to large code bases and is notoriously difficult to maintain.

If a script begins to grow beyond a few dozen lines, it is a good idea to refactor and rewrite, possibly adopting a new language better suited to growing. Python is a good choice as it has specific features aimed to make shell-like scripts easy to write but also many modern features including object-oriented programming and a modules system.

## Shell Tools

### System Health / State

You can easily view statistics of your system like CPU usage, memory usage, running processes, and more using the ``top``(table of processes) command. You can learn more on how to parse this output [here](https://www.redhat.com/en/blog/interpret-top-output). You can also use ``free`` but note that this is not avaliable on macOS.

### Finding files

One of the most common repetitive tasks that every programmer faces is finding files or directories.
All UNIX-like systems come packaged with [`find`](https://www.man7.org/linux/man-pages/man1/find.1.html), a great shell tool to find files. `find` will recursively search for files matching some criteria. Some examples:

```bash
# Find all directories named src
find . -name src -type d
# Find all python files that have a folder named test in their path
find . -path '*/test/*.py' -type f
# Find all files modified in the last day
find . -mtime -1
# Find all zip files with size in range 500k to 10M
find . -size +500k -size -10M -name '*.tar.gz'
```

Beyond listing files, find can also perform actions over files that match your query.
This property can be incredibly helpful to simplify what could be fairly monotonous tasks.

```bash
# Delete all files with .tmp extension
find . -name '*.tmp' -exec rm {} \;
# Find all PNG files and convert them to JPG
find . -name '*.png' -exec convert {} {}.jpg \;
```

Despite `find`'s ubiquitousness, its syntax can sometimes be tricky to remember.
For instance, to simply find files that match some pattern `PATTERN` you have to execute `find -name '*PATTERN*'` (or `-iname` if you want the pattern matching to be case insensitive).
You could start building aliases for those scenarios, but part of the shell philosophy is that it is good to explore alternatives.
Remember, one of the best properties of the shell is that you are just calling programs, so you can find (or even write yourself) replacements for some.
For instance, [`fd`](https://github.com/sharkdp/fd) is a simple, fast, and user-friendly alternative to `find`.
It offers some nice defaults like colorized output, default regex matching, and Unicode support. It also has, in my opinion, a more intuitive syntax.
For example, the syntax to find a pattern `PATTERN` is `fd PATTERN`.

Most would agree that `find` and `fd` are good, but some of you might be wondering about the efficiency of looking for files every time versus compiling some sort of index or database for quickly searching.
That is what [`locate`](https://www.man7.org/linux/man-pages/man1/locate.1.html) is for.
`locate` uses a database that is updated using [`updatedb`](https://www.man7.org/linux/man-pages/man1/updatedb.1.html).
In most systems, `updatedb` is updated daily via [`cron`](https://www.man7.org/linux/man-pages/man8/cron.8.html).
Therefore one trade-off between the two is speed vs freshness.
Moreover `find` and similar tools can also find files using attributes such as file size, modification time, or file permissions, while `locate` just uses the file name.
A more in-depth comparison can be found [here](https://unix.stackexchange.com/questions/60205/locate-vs-find-usage-pros-and-cons-of-each-other).

### Finding code

Finding files by name is useful, but quite often you want to search based on file *content*.
A common scenario is wanting to search for all files that contain some pattern, along with where in those files said pattern occurs.
To achieve this, most UNIX-like systems provide [`grep`](https://www.man7.org/linux/man-pages/man1/grep.1.html), a generic tool for matching patterns from the input text.
`grep` is an incredibly valuable shell tool that we will cover in greater detail during the data wrangling lecture.

For now, know that `grep` has many flags that make it a very versatile tool.
Some I frequently use are `-C` for getting **C**ontext around the matching line and `-v` for in**v**erting the match, i.e. print all lines that do **not** match the pattern. For example, `grep -C 5` will print 5 lines before and after the match.
When it comes to quickly searching through many files, you want to use `-R` since it will **R**ecursively go into directories and look for files for the matching string.

But `grep -R` can be improved in many ways, such as ignoring `.git` folders, using multi CPU support, &c.
Many `grep` alternatives have been developed, including [ack](https://github.com/beyondgrep/ack3), [ag](https://github.com/ggreer/the_silver_searcher) and [rg](https://github.com/BurntSushi/ripgrep).
All of them are fantastic and pretty much provide the same functionality.
For now I am sticking with ripgrep (`rg`), given how fast and intuitive it is. Some examples:

```bash
# Find all python files where I used the requests library
rg -t py 'import requests'
# Find all files (including hidden files) without a shebang line
rg -u --files-without-match "^#\!"
# Find all matches of foo and print the following 5 lines
rg foo -A 5
# Print statistics of matches (# of matched lines and files )
rg --stats PATTERN
```

Note that as with `find`/`fd`, it is important that you know that these problems can be quickly solved using one of these tools, while the specific tools you use are not as important.

## Finding shell commands

So far we have seen how to find files and code, but as you start spending more time in the shell, you may want to find specific commands you typed at some point.
The first thing to know is that typing the up arrow will give you back your last command, and if you keep pressing it you will slowly go through your shell history.

The `history` command will let you access your shell history programmatically.
It will print your shell history to the standard output.
If we want to search there we can pipe that output to `grep` and search for patterns.
`history | grep find` will print commands that contain the substring "find".

In most shells, you can make use of `Ctrl+R` to perform backwards search through your history.
After pressing `Ctrl+R`, you can type a substring you want to match for commands in your history.
As you keep pressing it, you will cycle through the matches in your history.
This can also be enabled with the UP/DOWN arrows in [zsh](https://github.com/zsh-users/zsh-history-substring-search).
A nice addition on top of `Ctrl+R` comes with using [fzf](https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings#ctrl-r) bindings.
`fzf` is a general-purpose fuzzy finder that can be used with many commands.
Here it is used to fuzzily match through your history and present results in a convenient and visually pleasing manner.

Another cool history-related trick I really enjoy is **history-based autosuggestions**.
First introduced by the [fish](https://fishshell.com/) shell, this feature dynamically autocompletes your current shell command with the most recent command that you typed that shares a common prefix with it.
It can be enabled in [zsh](https://github.com/zsh-users/zsh-autosuggestions) and it is a great quality of life trick for your shell.

You can modify your shell's history behavior, like preventing commands with a leading space from being included. This comes in handy when you are typing commands with passwords or other bits of sensitive information.
To do this, add `HISTCONTROL=ignorespace` to your `.bashrc` or `setopt HIST_IGNORE_SPACE` to your `.zshrc`.
If you make the mistake of not adding the leading space, you can always manually remove the entry by editing your `.bash_history` or `.zsh_history`.

## Directory Navigation

So far, we have assumed that you are already where you need to be to perform these actions. But how do you go about quickly navigating directories?
There are many simple ways that you could do this, such as writing shell aliases or creating symlinks with [ln -s](https://www.man7.org/linux/man-pages/man1/ln.1.html), but the truth is that developers have figured out quite clever and sophisticated solutions by now.

As with the theme of this course, you often want to optimize for the common case.
Finding frequent and/or recent files and directories can be done through tools like [`fasd`](https://github.com/clvv/fasd) and [`autojump`](https://github.com/wting/autojump).
Fasd ranks files and directories by [*frecency*](https://web.archive.org/web/20210421120120/https://developer.mozilla.org/en-US/docs/Mozilla/Tech/Places/Frecency_algorithm), that is, by both *frequency* and *recency*.
By default, `fasd` adds a `z` command that you can use to quickly `cd` using a substring of a *frecent* directory. For example, if you often go to `/home/user/files/cool_project` you can simply use `z cool` to jump there. Using autojump, this same change of directory could be accomplished using `j cool`.

More complex tools exist to quickly get an overview of a directory structure: [`tree`](https://linux.die.net/man/1/tree), [`broot`](https://github.com/Canop/broot) or even full fledged file managers like [`nnn`](https://github.com/jarun/nnn), [`ranger`](https://github.com/ranger/ranger), and [midnight commander `mc`](https://midnight-commander.org/).
