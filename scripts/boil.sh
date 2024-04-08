#!/usr/bin/env bash

selected_entry=$(find ~/.local/share/Steam/steamapps/ -maxdepth 1 -type f -name '*.acf' -exec awk -F '"' '/"appid|name/{ printf $4 "|" } END { print "" }' {} \; | column -t -s '|' | sort -k 2 | awk 'BEGIN{print "cancel"} {print $0}' | dmenu -l 20 -fn 'Hack Regular-12' -nb "#222222" -nf "#CCCCCC" -sb "#3FB36D" -sf "#FFFFFF") 

if [ "$selected_entry" = "cancel" ]; then
	exit 1
fi

selected_number=$(echo "$selected_entry" | awk '{print $1}')

steam -applaunch "$selected_number"
#steam "steam://rungameid/$selected_number"
#steamcmd +login garshnarg Cool3131 +app_run "$selected_number" +quit

