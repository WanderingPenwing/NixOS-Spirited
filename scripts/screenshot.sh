#!/usr/bin/env bash

type=$(echo -e "selection\nwindow\nscreen" | marukuru )

echo "$type"

if [ "$type" == "selection" ]; then
	maim --select "$HOME/pics/screenshots/$(date '+%Y_%m_%d %H:%M:%S')_selection.png"
fi

if [ "$type" = "window" ]; then
	maim -i $(xdotool getactivewindow) "$HOME/pics/screenshots/$(date '+%Y_%m_%d %H:%M:%S')_window.png"
fi

if [ "$type" == "screen" ]; then
	maim "$HOME/pics/screenshots/$(date '+%Y_%m_%d %H:%M:%S')_screen.png"
fi
