#!/usr/bin/env bash

option=$((echo "new"; ls -t ~/docs/notes) | marukuru -l 5 -p "edit note file :" )

if [[ $option == "" ]]; then
	notify-send -u low -a "notes" "no file selected"
	exit 1
fi

if [[ $option == "new" ]]; then
	name=$(marukuru -p "name :")

	if [[ $name == "" ]]; then
		name=$(date '+%Y_%m_%d-%H_%M')
	fi
	
	option="$name.md"
fi


kodama -e $EDITOR "$HOME/docs/notes/$option"
