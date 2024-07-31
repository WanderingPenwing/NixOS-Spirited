#!/usr/bin/env bash

app=$(ls ~/nixos/apps | marukuru -l 10 -p "update package : ")
path="/home/penwing/nixos/apps/${app}/install.nix"
repo=$(grep "repo" "${path}" | awk -F '"' '{print $2}')
new_version=$(echo "" | marukuru -p "version : ")
new_hash=$(nix flake prefetch "github:WanderingPenwing/${repo}/${new_version}" 2>&1 | sed -n "s/.*hash '\([^']*\)'.*/\1/p")

if [ "$new_hash" = "" ] || [ "$new_version" = "" ]; then
	notify-send -u critical -a "update"  "Could not get hash of ${app} with version ${new_version}"
	exit 1
fi

echo "${new_hash}"

sed -i "s|version = \".*\";|version = \"${new_version}\";|" "${path}"
sed -i "s|sha256 = \".*\";|sha256 = \"${new_hash}\";|" "${path}"

notify-send -u normal -a "update"  "Updated ${app} to version ${new_version}"
