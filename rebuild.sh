#!/usr/bin/env bash

echo "Trying to rebuild..."

set -e

# cd to your config dir
pushd /home/penwing/nixos/ > /dev/null 2>&1

# Early return if no changes were detected
if git diff --quiet; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

alejandra . &>/dev/null
# Shows your changes
git diff -U0

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo sh -c "nixos-rebuild switch &>nixos-switch.log || (cat nixos-switch.log | grep --color error && false)"

# Get current generation metadata
echo "Getting generation..."
current=$(nixos-rebuild list-generations 2>/dev/null | grep current | awk '{print $1}')

# Add all changes
git add .

# Commit all changes with the generation metadata
git commit -m "NixOS rebuild: Generation $current"

popd > /dev/null 2>&1

echo "Rebuild Successful"
