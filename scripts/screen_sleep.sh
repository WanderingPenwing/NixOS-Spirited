#! /usr/bin/env bash
#xset -dpms s off && notify-send -u normal -a "display" "disabled screen sleep"

status="$(xset q)"

if [[ $status == *"DPMS is Disabled"* ]]; then
	choice="$(echo -e enable sleep\\nscreen off | marukuru)"
else
	choice="$(echo -e disable sleep\\nscreen off | marukuru)"
fi

echo $choice

if [[ $choice == "enable sleep" ]]; then
	xset +dpms
	notify-send -u normal -a "display" "enabled screen sleep"
elif [[ $choice == "disable sleep" ]]; then
	xset -dpms s off
	notify-send -u normal -a "display" "disabled screen sleep"
elif [[ $choice == "screen off" ]]; then
	xset dpms force off
else
	notify-send -u low -a "display" "cancelled"
fi

