mode=$(echo -e "extension\ncopy" | marukuru -i)

if [ "$mode" == "extension" ]; then
  notify-send -u low -a "hdmi" "$(xrandr --output HDMI-1 --pos 1920x0 --mode 1920x1080 --rate 60 2>&1)"
elif [ "$mode" == "copy" ]; then
  notify-send -u low -a "hdmi" "$(xrandr --output HDMI-1 --pos 0x0 --mode 1920x1080 --rate 60 2>&1)"
else
  notify-send -u critical -a "hdmi" "invalid mode"
fi
