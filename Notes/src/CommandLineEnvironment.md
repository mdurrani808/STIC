In this lecture we will go through several ways in which you can improve your workflow when using the shell. We have been working with the shell for a while now, but we have mainly focused on executing different commands. We will now see how to run several processes at the same time while keeping track of them, how to stop or pause a specific process and how to make a process run in the background.

We will also learn about different ways to improve your shell and other tools, by defining aliases and configuring them using dotfiles. Both of these can help you save time, e.g. by using the same configurations in all your machines without having to type long commands. We will look at how to work with remote machines using SSH.

## Managing Processes
In some cases you will need to interrupt a job while it is executing, for instance if a command is taking too long to complete (such as a `find` with a very large directory structure to search through). Most of the time, you can do `Ctrl-C` and the command will stop. But how does this actually work and why does it sometimes fail to stop the process?
### Killing a Process
Your shell is using a UNIX communication mechanism called a _signal_ to communicate information to the process. When a process receives a signal it stops its execution, deals with the signal and potentially changes the flow of execution based on the information that the signal delivered. For this reason, signals are _software interrupts_.

In our case, when typing `Ctrl-C` this prompts the shell to deliver a `SIGINT` signal to the process.

Here's a minimal example of a Python program that captures `SIGINT` and ignores it, no longer stopping. To kill this program we can now use the `SIGQUIT` signal instead, by typing `Ctrl-\`. The difference between `SIGINT` and `SIGQUIT` is that `SIGQUIT` will produce a core dump once the process is terminated.

```python
#!/usr/bin/env python
import signal, time

def handler(signum, time):
    print("\nI got a SIGINT, but I am not stopping")

signal.signal(signal.SIGINT, handler)
i = 0
while True:
    time.sleep(.1)
    print("\r{}".format(i), end="")
    i += 1
```

While `SIGINT` and `SIGQUIT` are both usually associated with terminal related requests, a more generic signal for asking a process to exit gracefully is the `SIGTERM` signal. To send this signal we can use the [`kill`](https://www.man7.org/linux/man-pages/man1/kill.1.html) command, with the syntax `kill -TERM <PID>`.
### Pausing and Backgrounding Processes

Signals can do other things beyond killing a process. For instance, `SIGSTOP` pauses a process. In the terminal, typing `Ctrl-Z` will prompt the shell to send a `SIGTSTP` signal, short for Terminal Stop (i.e. the terminal's version of `SIGSTOP`).

We can then continue the paused job in the foreground or in the background using [`fg`](https://www.man7.org/linux/man-pages/man1/fg.1p.html) or [`bg`](http://man7.org/linux/man-pages/man1/bg.1p.html), respectively. The [`jobs`](https://www.man7.org/linux/man-pages/man1/jobs.1p.html) command lists the unfinished jobs associated with the current terminal session.
You can refer to those jobs using their pid (you can use [`pgrep`](https://www.man7.org/linux/man-pages/man1/pgrep.1.html) to find that out). More intuitively, you can also refer to a process using the percent symbol followed by its job number (displayed by `jobs`). To refer to the last backgrounded job you can use the `$!` special parameter.

One more thing to know is that the `&` suffix in a command will run the command in the background, giving you the prompt back, although it will still use the shell's STDOUT which can be annoying (use shell redirections in that case).

To background an already running program you can do `Ctrl-Z` followed by `bg`. Note that backgrounded processes are still children processes of your terminal and will die if you close the terminal (this will send yet another signal, `SIGHUP`).
To prevent that from happening you can run the program with [`nohup`](https://www.man7.org/linux/man-pages/man1/nohup.1.html) (a wrapper to ignore `SIGHUP`), or use `disown` if the process has already been started.

Below is a sample session to showcase some of these concepts.

```console
$ sleep 1000
^Z
[1]  + 18653 suspended  sleep 1000

$ nohup sleep 2000 &
[2] 18745
appending output to nohup.out

$ jobs
[1]  + suspended  sleep 1000
[2]  - running    nohup sleep 2000

$ bg %1
[1]  - 18653 continued  sleep 1000

$ jobs
[1]  - running    sleep 1000
[2]  + running    nohup sleep 2000

$ kill -STOP %1
[1]  + 18653 suspended (signal)  sleep 1000

$ jobs
[1]  + suspended (signal)  sleep 1000
[2]  - running    nohup sleep 2000

$ kill -SIGHUP %1
[1]  + 18653 hangup     sleep 1000

$ jobs
[2]  + running    nohup sleep 2000

$ kill -SIGHUP %2

$ jobs
[2]  + running    nohup sleep 2000

$ kill %2
[2]  + 18745 terminated  nohup sleep 2000

$ jobs

```

A special signal is `SIGKILL` since it cannot be captured by the process and it will always terminate it immediately. However, it can have bad side effects such as leaving orphaned children processes.

You can learn more about these and other signals [here](https://en.wikipedia.org/wiki/Signal_(IPC)) or typing [`man signal`](https://www.man7.org/linux/man-pages/man7/signal.7.html) or `kill -l`.
## Terminal Multiplexing
### Why?
When using the command line interface you will often want to run more than one thing at once. For instance, you might want to run your editor and your program side by side. Although this can be achieved by opening new terminal windows, using a terminal multiplexer is a more versatile solution.

Terminal multiplexers like [`tmux`](https://www.man7.org/linux/man-pages/man1/tmux.1.html) allow you to multiplex terminal windows using panes and tabs so you can interact with multiple shell sessions. Moreover, terminal multiplexers let you detach a current terminal session and reattach at some point later in time. This can make your workflow much better when working with remote machines since it avoids the need to use `nohup` and similar tricks.
### Tmux usage
`tmux` expects you to know its keybindings, and they all have the form `<C-b> x` where that means (1) press `Ctrl+b`, (2) release `Ctrl+b`, and then (3) press `x`. `tmux` has the following hierarchy of objects:

- **Sessions** - a session is an independent workspace with one or more windows
    - `tmux` starts a new session.
    - `tmux new -s NAME` starts it with that name.
    - `tmux ls` lists the current sessions
    - Within `tmux` typing `<C-b> d` detaches the current session
    - `tmux a` attaches the last session. You can use `-t` flag to specify which
- **Windows** - Equivalent to tabs in editors or browsers, they are visually separate parts of the same session
    - `<C-b> c` Creates a new window. To close it you can just terminate the shells doing `<C-d>`
    - `<C-b> N` Go to the _N_ th window. Note they are numbered
    - `<C-b> p` Goes to the previous window
    - `<C-b> n` Goes to the next window
    - `<C-b> ,` Rename the current window
    - `<C-b> w` List current windows
- **Panes** - Like vim splits, panes let you have multiple shells in the same visual display.
    - `<C-b> "` Split the current pane horizontally
    - `<C-b> %` Split the current pane vertically
    - `<C-b> <direction>` Move to the pane in the specified _direction_. Direction here means arrow keys.
    - `<C-b> z` Toggle zoom for the current pane
    - `<C-b> [` Start scrollback. You can then press `<space>` to start a selection and `<enter>` to copy that selection.
    - `<C-b> <space>` Cycle through pane arrangements.
For further reading, [here](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) is a quick tutorial on `tmux` and [this](http://linuxcommand.org/lc3_adv_termmux.php) has a more detailed explanation that covers the original `screen` command. You might also want to familiarize yourself with [`screen`](https://www.man7.org/linux/man-pages/man1/screen.1.html), since it comes installed in most UNIX systems.
## Shell Environment Customization
### Aliases
It can become tiresome typing long commands that involve many flags or verbose options. For this reason, most shells support _aliasing_. A shell alias is a short form for another command that your shell will replace automatically for you. For instance, an alias in bash has the following structure:
```bash
alias alias_name="command_to_alias arg1 arg2"
```

Note that there is no space around the equal sign `=`, because [`alias`](https://www.man7.org/linux/man-pages/man1/alias.1p.html) is a shell command that takes a single argument.

Aliases have many convenient features:

```bash
# Make shorthands for common flags
alias ll="ls -lh"

# Save a lot of typing for common commands
alias gs="git status"
alias gc="git commit"
alias v="vim"

# Save you from mistyping
alias sl=ls

# Overwrite existing commands for better defaults
alias mv="mv -i"           # -i prompts before overwrite
alias mkdir="mkdir -p"     # -p make parent dirs as needed
alias df="df -h"           # -h prints human readable format

# Alias can be composed
alias la="ls -A"
alias lla="la -l"

# To ignore an alias run it prepended with \
\ls
# Or disable an alias altogether with unalias
unalias la

# To get an alias definition just call it with alias
alias ll
# Will print ll='ls -lh'
```
Note that aliases do not persist shell sessions by default. To make an alias persistent you need to include it in shell startup files, like `.bashrc` or `.zshrc`, which we are going to introduce in the next section.
### Dotfiles
Many programs are configured using plain-text files known as _dotfiles_
(because the file names begin with a `.`, e.g. `~/.vimrc`, so that they are
hidden in the directory listing `ls` by default).

Shells are one example of programs configured with such files. On startup, your shell will read many files to load its configuration. Depending on the shell, whether you are starting a login and/or interactive the entire process can be quite complex.
[Here](https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html) is an excellent resource on the topic.

How should you organize your dotfiles? They should be in their own folder, under version control, and **symlinked** into place using a script. This has the benefits of:

- **Easy installation**: if you log in to a new machine, applying your customizations will only take a minute.
- **Portability**: your tools will work the same way everywhere.
- **Synchronization**: you can update your dotfiles anywhere and keep them all in sync.
- **Change tracking**: you're probably going to be maintaining your dotfiles for your entire programming career, and version history is nice to have for long-lived projects.

What should you put in your dotfiles?
You can learn about your tool's settings by reading online documentation or [man pages](https://en.wikipedia.org/wiki/Man_page). Another great way is to search the internet for blog posts about specific programs, where authors will tell you about their preferred customizations. Yet another way to learn about customizations is to look through other people's dotfiles: you can find tons of [dotfiles repositories](https://github.com/search?o=desc&q=dotfiles&s=stars&type=Repositories) on GitHub --- see the most popular one
[here](https://github.com/mathiasbynens/dotfiles) (we advise you not to blindly copy configurations though). [Here](https://dotfiles.github.io/) is another good resource on the topic.
## Remote Development
It has become more and more common for programmers to use remote servers in their everyday work. If you need to use remote servers in order to deploy backend software or you need a server with higher computational capabilities, you will end up using a Secure Shell (SSH). As with most tools covered, SSH is highly configurable so it is worth learning about it.

To `ssh` into a server you execute a command as follows

```
ssh foo@bar.mit.edu
```

Here we are trying to ssh as user `foo` in server `bar.mit.edu`. The server can be specified with a URL (like `bar.mit.edu`) or an IP (something like `foobar@192.168.1.42`). Later we will see that if we modify ssh config file you can access just using something like `ssh bar`.
### Executing commands
An often overlooked feature of `ssh` is the ability to run commands directly. `ssh foobar@server ls` will execute `ls` in the home folder of foobar. It works with pipes, so `ssh foobar@server ls | grep PATTERN` will grep locally the remote output of `ls` and `ls | ssh foobar@server grep PATTERN` will grep remotely the local output of `ls`.
### SSH keys

SSH keys provide a more secure and convenient way to log into an SSH server compared to using passwords. SSH keys come in pairs - a public key that gets shared with services you want to connect to, and a private key that you keep secret on your computer. 
#### Key Generation

You can generate an SSH key pair using the following command:

```console
ssh-keygen -t ed25519 -a 100
```

Here, we're using the Ed25519 algorithm which is currently recommended for most users. The `-a 100` increases the number of KDF (Key Derivation Function) rounds, making the key more resistant to brute-force attacks.

When you run ssh-keygen, you'll be prompted for a location to save the key pair. By default, this is `~/.ssh/id_ed25519` (or `id_rsa` for RSA keys). You'll also be asked for a passphrase. Using a passphrase is highly recommended as it encrypts your private key on disk.
#### Key based authentication
To use SSH key-based authentication, you need to add your public key to the remote server. The easiest way to do this is to use:
```console
ssh-copy-id -i ~/.ssh/id_ed25519.pub username@remote_host
```
Alternatively, you can manually add the public key by appending it to `~/.ssh/authorized_keys` on the remote server:
```console
cat ~/.ssh/id_ed25519.pub | ssh username@remote_host "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```
After adding your key, you can log in without a password (though you'll need to enter your key's passphrase if you set one).

You can simplify SSH connections even further by editing `~/.ssh/config`:

```
Host dev
    HostName dev.example.com
    User foobar
    IdentityFile ~/.ssh/id_ed25519
    Port 2222
```
Now you can simply type `ssh dev` instead of `ssh -p 2222 foobar@dev.example.com`.
##### Copying Files Over SSH
There are several ways to copy files over SSH:

- `scp` (secure copy) is the simplest for basic use:
  ```console
  scp path/to/local/file.txt remote:path/to/remote/file.txt
  ```
- `rsync` is more sophisticated, supporting resume and incremental transfers:
  ```console
  rsync -avz path/to/local/file.txt remote:path/to/remote/file.txt
  ```
- `sftp` provides an interactive file transfer session:
  ```console
  sftp remote
  > get remotefile.txt
  > put localfile.txt
  ```
#### Port Forwarding
SSH can forward ports between machines, which is incredibly useful for accessing network services securely. There are several types of port forwarding:

- Local forwarding (`-L`): Forwards a port from your local machine to the remote server
  ```console
  ssh -L 9999:localhost:80 user@remote_host
  ```
  This forwards your local port 9999 to port 80 on the remote host. You can then access the remote service by connecting to `localhost:9999`.
- Remote forwarding (`-R`): Forwards a port from the remote machine to your local machine
  ```console
  ssh -R 9999:localhost:80 user@remote_host
  ```
  This forwards port 9999 on the remote host to port 80 on your local machine.

