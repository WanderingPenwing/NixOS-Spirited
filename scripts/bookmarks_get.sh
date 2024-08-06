#!/usr/bin/env bash

item=$(grep "\S" ~/nixos/scripts/save/bookmarks | marukuru -i -l 15)

setxkbmap fr
xdotool type "${item% #*}"
