#!/usr/bin/env bash

selection="$(xclip -o | tr '\n' ';' | awk '{$1=$1};1')"
file="$HOME/nixos/scripts/save/bookmarks"

if grep -q "^$selection$" "$file"; then
	notify-send -u low -a "bookmarks" "already registered"
	exit 0
fi

echo "$selection" >> "$file"

notify-send -u normal -a "bookmarks" "added $selection"
