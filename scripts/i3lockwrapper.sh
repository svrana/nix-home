#!/usr/bin/env bash


i3lock_running() {
    pid=$(pidof i3lock)
    if [ -n "$pid" ]; then
        echo "i3lock already running"
        return 0
    fi
    return 1
}


lock() {
    # save current workspace
    current=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true).name' | cut -d"\"" -f2)

    # go to empty workspace
    i3-msg workspace 7

    # startup lock, blocking until unlocked
    #i3-msg workspace 7 && i3-msg workspace 7 && i3lock -l -c 002b36 --ignore-empty-password --no-unlock-indicator --clock --nofork --datestr="%A, %B %d %G" --timesize=48 --datesize=24
    #i3lock -c 002b36 --ignore-empty-password --no-unlock-indicator --clock --nofork --datestr="%A, %B %d %G" --timesize=48 --datesize=24
    i3lock -c 002b36 --ignore-empty-password --no-unlock-indicator --clock --nofork --datestr="%A, %B %d %G" --timesize=48 --datesize=24

    #echo "$PATH" > /home/shaw/switchto

    # go to previous workspace
    i3-msg workspace "$current"
}

main() {
    if i3lock_running ; then
        return 0
    fi

    lock
    return 0
}

main
