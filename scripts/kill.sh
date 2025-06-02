#!/usr/bin/env bash

process=$(ps -u $USER -o pid,comm | marukuru -i -l 10 -p "kill" | awk '{print $2}')

if [[ $process == "" ]]; then
	notify-send -u low -a "Kill" "no process selected"
	exit 1
fi

pkill $process
