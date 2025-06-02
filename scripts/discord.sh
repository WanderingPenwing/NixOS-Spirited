#! /usr/bin/env bash

easyeffects --gapplication-service &
easyeffects -l "mic"
notify-send -u normal -a "mic filter" "filter enabled"
discord
pkill easyeffects
