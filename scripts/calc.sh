#!/usr/bin/env bash

notify-send -a "Result" $(marukuru -p "Calculate : " <&- | calc -p)
