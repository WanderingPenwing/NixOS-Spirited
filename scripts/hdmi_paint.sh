mode=$(echo -e "extension\ncopy" | marukuru -i)

if [ "$mode" == "extension" ]; then
	notify-send -u low -a "hdmi" "$(xrandr --output HDMI-A-0 --right-of eDP --auto 2>&1)"
elif [ "$mode" == "copy" ]; then
	notify-send -u low -a "hdmi" "$(xrandr --output HDMI-A-0 --same-as eDP --auto 2>&1)"
else
  notify-send -u low -a "hdmi" "cancelled"
fi

feh --bg-scale "$HOME/nixos/wallpapers/main.png"
