#!/usr/bin/env bash

type=$(echo -e "sinks\nsources" | marukuru -c -bw 6)

if [ "$type" == "sinks" ]; then
	selected_sink=$(pamixer --list-sinks | awk -F '"' 'NR>1 {print $1 $6}' | marukuru -c -bw 6 -l 10 | awk '{print $1}' )
	volume=$(pamixer --sink "$selected_sink" --get-volume)
	status=$(pamixer --sink "$selected_sink" --get-mute | sed -e 's/true/muted/g' -e 's/false//g')
	selected_action=$(echo -e "toggle mute\nchange volume" | marukuru -l 2 -c -bw 6 -p "sink $selected_sink ($volume% $status)")
	if [ "$selected_action" == "toggle mute" ]; then
		output=$(pamixer --sink "$selected_sink" -t 2>&1)
	else 
		volume=$(marukuru -c -bw 6 -p "new volume : ")
		output=$(pamixer --sink "$selected_sink" --set-volume "$volume")
	fi
	if [ "$output" == "" ]; then 
		volume=$(pamixer --sink "$selected_sink" --get-volume)
		status=$(pamixer --sink "$selected_sink" --get-mute | sed -e 's/true/muted/g' -e 's/false//g')
		notify-send -u normal -a "mixer" "sucessfully modified sink $selected_sink to ($volume% $status)"
	else
		notify-send -u critical -a "mixer" "$output"
	fi
elif [ "$type" == "sources" ]; then
	selected_source=$(pamixer --list-sources | awk -F '"' 'NR>1 {print $1 $6}' | marukuru -c -bw 6 -l 10 | awk '{print $1}' )
	volume=$(pamixer --source "$selected_source" --get-volume)
	status=$(pamixer --source "$selected_source" --get-mute | sed -e 's/true/muted/g' -e 's/false//g')
	selected_action=$(echo -e "toggle mute\nchange volume" | marukuru -l 2 -c -bw 6 -p "sink $selected_source ($volume% $status)")
	if [ "$selected_action" == "toggle mute" ]; then
		output=$(pamixer --source "$selected_source" -t 2>&1)
	else 
		volume=$(marukuru -c -bw 6 -p "new volume : ")
		output=$(pamixer --source "$selected_source" --set-volume "$volume")
	fi
	if [ "$output" == "" ]; then 
		volume=$(pamixer --source "$selected_source" --get-volume)
		status=$(pamixer --source "$selected_source" --get-mute | sed -e 's/true/muted/g' -e 's/false//g')
		notify-send -u normal -a "mixer" "sucessfully modified source $selected_source to ($volume% $status)"
	else
		notify-send -u critical -a "mixer" "$output"
	fi
else
	notify-send -u low -a "mixer" "aborted"
fi


