#!/usr/bin/env bash

echo "Trying to rebuild..."

set -e

# cd to your config dir
pushd /home/penwing/nixos/ > /dev/null 2>&1

# Early return if no changes were detected
if git diff --quiet && [ $# -eq 0 ]; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

# Shows your changes
git diff -U0

echo ""
computer_name=$(cat /home/penwing/nixos/computer_name)
echo "NixOS Rebuilding $computer_name ..."
# Rebuild, output simplified errors, log trackebacks
#sudo sh -c "nixos-rebuild switch &>nixos-switch.log || (cat nixos-switch.log | grep --color error && false)"
sudo nixos-rebuild switch --flake "/home/penwing/nixos#$computer_name"
# | grep -v "warning: Git tree '/home/penwing/nixos' is dirty"

echo "Rebuild Successful"

echo ""
# Get current generation metadata
echo "Getting generation..."
current=$(nixos-rebuild list-generations 2>/dev/null | grep current | awk '{print $1}')

# Add all changes
git add .

# Commit all changes with the generation metadata
git commit -m "NixOS rebuild: Generation $current"

echo "Setting up..."
betterlockscreen -u ~/nixos/wallpapers/main.png --fx > /dev/null 2>&1

popd > /dev/null 2>&1

echo "Finished"
