#!/usr/bin/env bash

APPS=("cancel" "seafile-applet" "discord" "prismlauncher" "noisetorch" "pavucontrol" "jiji" "calcifer" "gimp" "blockbench-electron" "jellyfinmediaplayer" "poweroff" "reboot")

# Join the array elements with newlines
APPS_STRING=$(printf "%s\n" "${APPS[@]}")

# Pass the filtered list to dmenu
SELECTED_APP=$(echo -e "$APPS_STRING" | dmenu -i -fn 'Mononoki Nerd Font:size=16' -nb "#222222" -nf "#CCCCCC" -sb "#3fb36d" -sf "#eeeeee")

# Run the selected application
if [ "$SELECTED_APP" != "cancel" ] && [ -n "$SELECTED_APP" ]; then
    "$SELECTED_APP" &
fi
