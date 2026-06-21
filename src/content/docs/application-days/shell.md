---
title: Shell Application Day
description: Shell Application Day for CMSC398W.
---

Build a command-line todo list manager in Bash. The app stores todos in a file and supports adding, viewing, completing, removing, and cleaning up tasks.

Repository: [https://github.com/cmsc398w/STIC](https://github.com/cmsc398w/STIC)

Submit your `todo.sh` script on Gradescope.

---

## What to Build

Your script must support these commands:

| Command | Description |
|---------|-------------|
| `./todo.sh add <task>` | Add a new task |
| `./todo.sh done <number(s)>` | Mark task(s) complete |
| `./todo.sh rm <number>` | Remove a task |
| `./todo.sh clean` | Remove all completed tasks |
| `./todo.sh` | Display all tasks |

### Storage Format

Store todos in a plain text file, one per line, using `[ ]` for incomplete and `[x]` for complete.

### Display Format

Show tasks with line numbers and emoji status indicators:

- Incomplete: ⬜
- Complete: ✅

```
$ ./todo.sh
     1  ⬜ Buy groceries
     2  ✅ Finish homework
     3  ⬜ Call dentist
```

## Example Session

```bash
$ ./todo.sh add "Buy groceries"
Added: Buy groceries

$ ./todo.sh add "Finish homework"
Added: Finish homework

$ ./todo.sh add "Call dentist"
Added: Call dentist

$ ./todo.sh
     1  ⬜ Buy groceries
     2  ⬜ Finish homework
     3  ⬜ Call dentist

$ ./todo.sh done 1
Completed task #1

$ ./todo.sh
     1  ✅ Buy groceries
     2  ⬜ Finish homework
     3  ⬜ Call dentist

$ ./todo.sh rm 3
Removed task #3

$ ./todo.sh clean
Cleaned up 1 completed tasks
```

## Useful Tools

| Command | Suggested use |
|---------|---------------|
| `echo` | `add` |
| `sed` | `done`, `rm` |
| `grep` + redirection | `clean` |
| `cat -n` | display |

## Starter Code

```bash
#!/bin/bash
# todo - Simple todo list manager

TODO_FILE="$HOME/.todos"

add_todo() {
    echo "IMPLEMENT ME!!"
}

# Write other functions here...

touch $TODO_FILE

case "$1" in
    add)    shift; add_todo "$@" ;;
    # add other cases here...
esac
```

## Grading (25 pts)

5 points per function. A good-faith attempt on each part counts.
