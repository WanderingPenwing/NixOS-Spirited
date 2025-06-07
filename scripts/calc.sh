#!/usr/bin/env bash

notify-send -a "Result" "$(marukuru -c -bw 6 -p "Calculate : " <&- | calc -p)"
