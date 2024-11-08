#!/usr/bin/env bash

network=$(nmcli device wifi | awk 'NR>1 {print ($1 == "*" ? "*"$3 : $2)}' | sort | uniq | marukuru -l 10)

if nmcli device wifi connect "$network"; then
	notify-send -u normal -a "wifi" "connected to $network"
else
	notify-send -u high -a "wifi" "failed to connected to $network"
fi
