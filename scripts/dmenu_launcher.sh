#!/usr/bin/env bash

APPS=("" "steam" "gimp" "hmcl" "discord" "noisetorch" "calcifer" "jiji" "godot4" "torrential" "wifi" "poweroff" "reboot" "update" "blender" "ModrinthApp" "kill")

# Join the array elements with newlines
APPS_STRING=$(printf "%s\n" "${APPS[@]}")

# Pass the filtered list to dmenu
SELECTED_APP=$(echo -e "$APPS_STRING" | marukuru )

if [ "$SELECTED_APP" == "update" ]; then
	 ~/nixos/scripts/update.sh &
	 exit 0
fi

if [ "$SELECTED_APP" == "wifi" ]; then
	 ~/nixos/scripts/wifi_connect.sh &
	 exit 0
fi

if [ "$SELECTED_APP" == "torrential" ]; then
	"com.github.davidmhewitt.torrential" &
	exit 0
fi

if [ "$SELECTED_APP" == "discord" ]; then
	 ~/nixos/scripts/discord.sh &
	 exit 0
fi

# Run the selected application
if [ "$SELECTED_APP" != "" ] && [ -n "$SELECTED_APP" ]; then
    "$SELECTED_APP" &
fi
