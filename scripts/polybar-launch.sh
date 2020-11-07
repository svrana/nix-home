#!/usr/bin/env bash

# Terminate already running bar instances
killall -rq polybar

# Launch polybar
polybar top &
