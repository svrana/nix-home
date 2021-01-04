#!/usr/bin/env bash

pid=$(pgrep -f autotiling.py)
if [ ! -z "$pid" ]; then
    kill "$pid"
fi

nohup autotiling > /dev/null 2>&1 &
