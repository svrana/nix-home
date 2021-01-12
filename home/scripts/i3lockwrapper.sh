#!/usr/bin/env bash


i3lock_running() {
    pid=$(pidof i3lock)
    if [ -n "$pid" ]; then
        echo "i3lock already running"
        return 0
    fi
    return 1
}

screenblank_enable() {
    xset +dpms
    xset s on
}

screenblank_disable() {
    xset -dpms
    xset s off
}

lock() {
    # save current workspace
    current=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true).name' | cut -d"\"" -f2)
    # go to empty workspace in case I end up typing in a password and its not locked, so it doesn't end up in slack or something silly
    i3-msg workspace 7

    screenblank_enable
    i3lock-color -c 002b36 --ignore-empty-password --no-unlock-indicator --clock --nofork --datestr="%A, %B %d %G" --timesize=48 --datesize=24
    screenblank_disable

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
