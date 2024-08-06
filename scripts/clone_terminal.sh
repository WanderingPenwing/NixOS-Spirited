#!/usr/bin/env bash

# Get the current directory
current_dir=$(pwd)

# Command to open a new terminal window with the current directory
kodama -e sh -c "cd \"$current_dir\"; exec $SHELL" >/dev/null 2>&1 &
