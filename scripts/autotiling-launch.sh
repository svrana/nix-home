#!/usr/bin/env bash

pid=$(pgrep -f autotiling.py)
if [ ! -z "$pid" ]; then
    kill "$pid"
fi

nohup python3 /home/shaw/Apps/autotiling/autotiling.py > /dev/null 2>&1 &
