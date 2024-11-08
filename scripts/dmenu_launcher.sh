#!/usr/bin/env bash

APPS=("" "steam" "update" "hmcl" "obsidian" "discord" "noisetorch" "calcifer" "com.github.davidmhewitt.torrential" "wifi" "poweroff" "reboot")

# Join the array elements with newlines
APPS_STRING=$(printf "%s\n" "${APPS[@]}")

# Pass the filtered list to dmenu
SELECTED_APP=$(echo -e "$APPS_STRING" | marukuru )

if [ "$SELECTED_APP" == "seafile-kill" ]; then
	 ~/nixos/scripts/seafile_kill.sh &
	 exit 0
fi

if [ "$SELECTED_APP" == "update" ]; then
	 ~/nixos/scripts/update.sh &
	 exit 0
fi

if [ "$SELECTED_APP" == "wifi" ]; then
	 ~/nixos/scripts/wifi_connect.sh &
	 exit 0
fi

# Run the selected application
if [ "$SELECTED_APP" != "cancel" ] && [ -n "$SELECTED_APP" ]; then
    "$SELECTED_APP" &
fi
