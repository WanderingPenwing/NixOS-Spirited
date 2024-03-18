#!/usr/bin/env bash

set -e

# cd to your config dir
pushd /home/penwing/dotfiles/nixos/ > /dev/null 2>&1

# Early return if no changes were detected (thanks @singiamtel!)
if git diff --quiet *.nix; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

alejandra . &>/dev/null
# Shows your changes
git diff -U0 *.nix

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo sh -c "nixos-rebuild switch &>nixos-switch.log || (cat nixos-switch.log | grep --color error && false)"

# Get current generation metadat
echo "Getting generation..."
current=$(nixos-rebuild list-generations 2>/dev/null | grep current | awk '{print $1}')

# Commit all changes witih the generation metadata
git commit -am "$current"

popd > /dev/null 2>&1

echo "Rebuild Successful"
