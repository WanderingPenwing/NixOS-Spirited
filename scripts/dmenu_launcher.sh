#!/usr/bin/env bash

APPS=("steam" "gimp" "hmcl" "calcifer" "jiji" "godot4" "torrential" "reboot" "poweroff" "blender" "nheko" "audacity") 

# Join the array elements with newlines
APPS_STRING=$(printf "%s\n" "${APPS[@]}")

SCRIPTS_STRING=$(ls ~/nixos/scripts)
# Pass the filtered list to dmenu
SELECTED_APP=$(echo -e "$APPS_STRING\n$SCRIPTS_STRING" | marukuru -c -bw 6 -l 15)

if [ "$SELECTED_APP" == "torrential" ]; then
	"com.github.davidmhewitt.torrential" &
	exit 0
fi

if [[ "$SELECTED_APP" == *.sh ]]; then
	OUTPUT="$("$HOME/nixos/scripts/$SELECTED_APP" 2>&1)"
	STATUS=$?
	if [[ $STATUS -eq 1 ]]; then
		notify-send -u critical -a "$SELECTED_APP" "$OUTPUT"
	fi
	 exit 0
fi

# Run the selected application
if [ "$SELECTED_APP" != "" ] && [ -n "$SELECTED_APP" ]; then
    "$SELECTED_APP" &
fi
