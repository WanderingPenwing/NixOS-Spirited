#!/usr/bin/env bash

msg="pwd"

while true; do
    # Prompt for the password using dmenu
    password=$(marukuru -P -p "$msg :")
    # Check if the password is empty
    if [ -z "$password" ]; then
        echo "No password provided."
        notify-send -u low -a "sudo" "aborted"
        exit 1
    fi

    # Execute the command with sudo
    result=$(echo "$password" | sudo -S $@ 2>&1)
    
    # Check the exit status of sudo
    if [ $? -eq 0 ]; then
    	echo "success"
        break  # Break the loop if sudo was successful
    else
    	error=$(echo "$result" | sed 's/\[sudo\] password for penwing: //')
    	notify-send -u critical -a "sudo" "$error"
        msg="try again"
    fi
done
