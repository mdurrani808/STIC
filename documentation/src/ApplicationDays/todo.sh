#!/bin/bash
# todo - Simple todo list manager

TODO_FILE="$HOME/.todos"

function add_todo() {           # with 'function'
    echo "[ ] $*" >> "$TODO_FILE"
    echo "Added: $*"
}

show_todos() {                  # or without is the same
    cat -n "$TODO_FILE" | sed 's/\[ \]/ ⬜/g' | sed 's/\[x\]/ ✅/g'
}

complete_todo() {
    for num in "$@"; do
        # works on Linux; no parameter after -i
        sed -i "${num}s/\[ \]/[x]/" "$TODO_FILE"
        # # failed on Linux as pattern was taken as the file name
        # sed -i "" "${num}s/\[ \]/[x]/" "$TODO_FILE"
        echo "Completed task #$num"
    done
}

cleanup() {
    local count=$(grep -c "\[x\]" "$TODO_FILE")

    # # Original which fails on removing all items
    # grep -v "\[x\]" "$TODO_FILE" > temp && mv temp "$TODO_FILE"

    # corrected which ALWAYS moves the temp file 
    grep -v "\[x\]" "$TODO_FILE" > temp
    mv temp "$TODO_FILE"
    echo "Cleaned up $count completed tasks"
}

remove_todo() {
    sed -i "${1}d" "$TODO_FILE"
    # sed -i "" "${1}d" "$TODO_FILE"
    echo "Removed task #$1"
}

# only create the file if it isn't present
if [[ ! -e $TODO_FILE ]]; then
    touch $TODO_FILE
fi

case "$1" in
    add)    shift; add_todo "$@" ;;
    done)   shift; complete_todo "$@" ;;
    rm)     remove_todo "$2" ;;
    clean)  cleanup ;;
    *)      show_todos ;;
esac
