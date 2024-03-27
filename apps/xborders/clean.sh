#!/usr/bin/env bash

# Specify the process name
process_name="..xborders-wrap"

# Function to check for and kill the oldest instance of the process
kill_oldest_instance() {
    # Get the PID of the oldest instance
    oldest_pid=$(pgrep -o "$process_name")
    
    # If there is a PID, kill the process
    if [ -n "$oldest_pid" ]; then
        #echo "Terminating the oldest instance of $process_name with PID $oldest_pid"
        kill "$oldest_pid"
    fi
}

# Loop until there are no duplicate instances left
while [ "$(pgrep -c "$process_name")" -gt 1 ]; do
    kill_oldest_instance
    sleep 1 # Add a small delay to allow the process to terminate
done

#echo "No duplicate instances of $process_name found."
