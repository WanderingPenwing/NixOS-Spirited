#!/usr/bin/env bash

file=~/nixos/scripts/susuwatari/history.txt
separator="###SEPARATOR###"

# Select entry using dmenu
entry=$(grep -A 1 "$separator" "$file" | grep -v '^--$' | grep -Fv "$separator" | tac | awk 'BEGIN{print "cancel"} {print NR, $0}' | dmenu -l 10 -fn 'Hack Regular-12' -nb "#222222" -nf "#CCCCCC" -sb "#3FB36D" -sf "#FFFFFF")

# Extract selected entry number
selected=$(echo "$entry" | cut -d' ' -f1)

if [ "$entry" == "cancel" ]; then
   exit 1
fi

# Count occurrences of separator in the file
occurrences=$(grep -oF "$separator" "$file" | wc -l)

# Calculate the line number of selected entry
number=$((occurrences - selected + 1))

# Extract text of selected entry
text=$(awk -v RS="$separator" -v number="$number" 'NR==number' "$file" | tail -n +2)

if [ $# -eq 1 ]; then
  echo "$entry"
  echo "$number"
  echo "$text"
fi

# Switch keyboard layout to French
setxkbmap fr

# Simulate typing the text with xdotool
xdotool type --delay 0 "$text" 2>&1 > /dev/null
