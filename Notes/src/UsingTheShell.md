## What is the shell?

Computers these days have a variety of interfaces for giving them commands; fanciful graphical user interfaces, voice interfaces, and even AR/VR are everywhere. These are great for 80% of use-cases, but they are often fundamentally restricted in what they allow you to do — you cannot press a button that isn’t there or give a voice command that hasn’t been programmed. To take full advantage of the tools your computer provides, we have to go old-school and drop down to a textual interface: The Shell.


[Shell](https://www.gnu.org/software/bash/manual/html_node/What-is-a-shell_003f.html): A shell is simply a macro processor that executes commands. The term macro processor means functionality where text and symbols are expanded to create larger expressions. This is the program that is prompting you for commands and processing them.

Nearly all platforms you can get your hands on have a shell in one form or another, and many of them have several shells for you to choose from. While they may vary in the details, at their core they are all roughly the same: they allow you to run programs, give them input, and inspect their output in a semi-structured way.

In this lecture, we will focus on the Bourne Again SHell, or “bash” for short. This is one of the most widely used shells, and its syntax is similar to what you will see in many other shells. To open a shell prompt (where you can type commands), you first need a terminal. Your device probably shipped with one installed, or you can install one fairly easily.
## Using the shell

A terminal (or these days, more aptly, a terminal emulator) is a wrapper program which runs a shell. When you launch the terminal, you will see a prompt that will look like this:

```console
username@domain directory$
```

This is the main text based interface to the shell, and the prompt tells us some important information.

It displays the user that is currently logged in as (username), the machine you are logged into (domain), and the current directory you are in. The following symbol, in our case $, indicates a user level shell, while a root shell will be indicated by a hash sign (#).

Inside of this prompt, you can type a command, which will then be interpreted / executed by the shell. The most basic command is to execute a program:

```bash
cmsc398w:~$ date
Sat Nov 30 23:24:14 EST 2024
cmsc398w:~$
```

Here, we executed the `date` program, which (perhaps unsurprisingly) prints the current date and time. The shell then asks us for another command to execute. We can also execute a command with _arguments_:

```bash
cmsc398w:~$ echo hi
hi
```

In this case, we told the shell to execute the program `echo` with the argument `hello`. The `echo` program simply prints out its arguments. The shell parses the command by splitting it by whitespace, and then runs the program indicated by the first word, supplying each subsequent word as an argument that the program can access. If you want to provide an argument that contains spaces or other special characters (e.g., a directory named “My Photos”), you can either quote the argument with `'` or `"` (`"My Photos"`), or escape just the relevant characters with `\` (`My\ Photos`).

But how does the shell know how to find the `date` or `echo` programs? Well, the shell is a programming environment, just like Python or Ruby, and so it has variables, conditionals, loops, and functions (next lecture!). When you run commands in your shell, you are really writing a small bit of code that your shell interprets. If the shell is asked to execute a command that doesn’t match one of its programming keywords, it consults an _environment variable_ called `$PATH` that lists which directories the shell should search for programs when it is given a command:

```bash
cmsc398w:~$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
cmsc398w:~$ which echo
/usr/bin/echo
cmsc398w:~$ /bin/echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
```

When we run the `echo` command, the shell sees that it should execute the program `echo`, and then searches through the `:`-separated list of directories in `$PATH` for a file by that name. When it finds it, it runs it (assuming the file is _executable_; more on that later). We can find out which file is executed for a given program name using the `which` program. We can also bypass `$PATH` entirely by giving the _path_ to the file we want to execute.
## Navigating in the shell
A path (in the context of the shell) is a list of directories; separated by `/` on Linux and macOS and `\` on Windows. On Linux and macOS, the path `/` is the "root" of the file system, under which all directories and files lie, whereas on Windows there is one root for each disk partition (e.g., `C:\`). We will generally assume that you are using a Linux filesystem in this class. A path that starts with `/` is called an _absolute_ path. Any other path is a _relative_ path. Relative paths are relative to the current working directory, which we can see with the `pwd` command and change with the `cd` command. In a path, `.` refers to the current directory, and `..` to its parent directory.

```admonish info
``cd [directory]``: Changes current working directory

``pwd``: Prints the current working directory

```

```bash
cmsc398w:~/stic$ pwd
/home/mdurrani/stic
cmsc398w:~/stic$ cd /home
cmsc398w:/home$ pwd
/home
cmsc398w:/home$ cd ..
cmsc398w:/$ pwd
/
cmsc398w:/$ cd ./home
cmsc398w:/home$ pwd
/home
cmsc398w:/home$ cd mdurrani/stic
cmsc398w:~/stic$ pwd
/home/mdurrani/stic
cmsc398w:~$ ../../bin/echo hello
hello
```
Notice that our shell prompt kept us informed about what our current working directory was. You can configure your prompt to show you all sorts of useful information, which we will cover in a later lecture.

In general, when we run a program, it will operate in the current directory unless we tell it otherwise. For example, it will usually search for files there, and create new files there if it needs to.

To see what lives in a given directory, we use the `ls` command:

```admonish info
``ls [OPTION]... [FILE]...``: list directory contents
```
```bash
cmsc398w:~/stic$ ls
README.md  SystemMonitoringSolution
cmsc398w:~/stic$ cd /
cmsc398w:/$ ls
bin
boot
dev
etc
home
...
```
Unless a directory is given as its first argument, `ls` will print the contents of the current directory. Most commands accept flags and options (flags with values) that start with `-` to modify their behavior. Usually, running a program with the `-h` or `--help` flag will print some help text that tells you what flags and options are available. For example, `ls --help` tells us:

```
  -l                         use a long listing format
```

```console
cmsc398w:/$ ls -l /home
total 4
drwxr-x--- 67 cmsc398w cmsc398w 4096 Dec  2 19:22 cmsc398w
```
This gives us a bunch more information about each file or directory present. First, the `d` at the beginning of the line tells us that `cmsc398w` is a directory. Then follow three groups of three characters (`rwx`). These indicate what permissions the owner of the file (`cmsc398w`), the owning group (`users`), and everyone else respectively have on the relevant item. A `-` indicates that the given principal does not have the given permission. Above, only the owner is allowed to
modify (`w`) the `cmsc398w` directory (i.e., add/remove files in it). To enter a directory, a user must have "search" (represented by "execute": `x`) permissions on that directory (and its parents). To list its contents, a user must have read (`r`) permissions on that directory. For files, the permissions are as you would expect. Notice that nearly all the files in `/bin` have the `x` permission set for the last group, "everyone else", so that anyone can execute those programs.

```admonish info
``mv [OPTION]... SOURCE... DIRECTORY``: Rename SOURCE to DEST, or move SOURCE(s) to DIRECTORY.

``cp [OPTION]... SOURCE... DIRECTORY``: Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY.
```

If you ever want _more_ information about a program's arguments, inputs, outputs, or how it works in general, give the `man` program a try. It takes as an argument the name of a program, and shows you its _manual page_. Press `q` to exit.
```console
cmsc398w:~$ man ls
```

#### Searching man pages

Often times, you will want to search for a specific flag or action within the man pages for a command. To do this, you can type ``/[regex]`` where ``[regex]`` is a valid regular expression and then hit enter. For example, if I wanted to search for the flag ``-B``, I would type ``/-B``.

Other times, it may be more convenient to use the online versions of these man pages, which can be found here: https://man7.org/linux/man-pages/. Alternatively, you could use ``curl cheat.sh/[yourcommand]``, which uses cheat.sh to give you nice examples for the command you want to run.

[TLDR pages](https://tldr.sh/) are a nifty complementary solution that focuses on giving example use cases of a command so you can quickly figure out which options to use.


## Connecting Programs
In the shell, programs have two primary "streams" associated with them: their input stream and their output stream. When the program tries to read input, it reads from the input stream, and when it prints something, it prints to its output stream. Normally, a program's input and output are both your terminal. That is, your keyboard as input and your screen as output. However, we can also rewire those streams!

The simplest form of redirection is `< file` and `> file`. These let you rewire the input and output streams of a program to a file respectively:
```console
mdurrani@MDXPS139380:~/stic$ echo hello > hello.txt
mdurrani@MDXPS139380:~/stic$ cat hello.txt
hello
mdurrani@MDXPS139380:~/stic$ cat < hello.txt
hello
mdurrani@MDXPS139380:~/stic$ cat < hello.txt > hello2.txt
mdurrani@MDXPS139380:~/stic$ cat hello2.txt
hello
mdurrani@MDXPS139380:~/stic$
```

Demonstrated in the example above, `cat` is a program that con`cat`enates files. When given file names as arguments, it prints the contents of each of the files in sequence to its output stream. But when `cat` is not given any arguments, it prints contents from its input stream to its output stream (like in the third example above).

You can also use `>>` to append to a file. Where this kind of input/output redirection really shines is in the use of _pipes_. The `|` operator lets you "chain" programs such that the output of one is the
input of another:

```console
missing:~$ ls -l / | tail -n1
drwxr-xr-x 1 root  root  4096 Jun 20  2019 var
missing:~$ curl --head --silent google.com | grep --ignore-case content-length | cut --delimiter=' ' -f2
219
```

