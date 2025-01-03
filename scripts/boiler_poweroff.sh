#!/usr/bin/env bash

echo "----"

# Define the URL of your Jellyfin server API
JELLYFIN_API_URL="https://movie.penwing.org"

# Define your API key
API_KEY=$(cat ~/keys/jellyfin_api)

# Make a GET request to the System Info endpoint with the API key included in the Authorization header
SESSIONS=$(curl -s -H "X-MediaBrowser-Token: $API_KEY" "$JELLYFIN_API_URL/Sessions")

if [ "$SESSIONS" = "error code: 1033" ]; then
	echo "error"
	poweroff
fi

# Extract usernames using awk and remove duplicates
USERNAMES=$(echo "$SESSIONS" | awk -F'"UserName":"' '{for (i=2; i<=NF; i++) {print substr($i, 1, index($i, "\"")-1)}}' | awk '!seen[$0]++')


# Count the number of unique usernames
if [ -z "$USERNAMES" ]; then
  NUM_USERNAMES=0
else
  NUM_USERNAMES=$(echo "$USERNAMES" | wc -l)
fi

echo "$NUM_USERNAMES"

if [ "$NUM_USERNAMES" -eq "0" ]; then
  poweroff
fi
