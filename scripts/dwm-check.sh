#! /usr/bin/env bash

# Check if the directory is passed as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Directory to search
SEARCH_DIR="$1"

# Find all binaries named 'dwm' in the specified directory and its subdirectories
find "$SEARCH_DIR" -name "dwm" | while read -r binary; do
  # Execute the binary with the '-v' argument and capture the output
  result=$("$binary" -v 2>&1)
  # Display the binary path and its result
  echo "$binary : \"$result\""
done
