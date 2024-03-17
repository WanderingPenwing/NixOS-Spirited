#!/usr/bin/env bash
#
# Borrowed from github user 0atman
# A rebuild script that commits on a successful build

set -e

# cd to your config dir
pushd /home/penwing/dotfiles/nixos/ > /dev/null 2>&1

# Early return if no changes were detected (thanks @singiamtel!)
if git diff --quiet *.nix; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

# Shows your changes
git diff -U0 *.nix

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
if sudo nixos-rebuild switch >nixos-switch.log 2>&1; then
    echo "Rebuild successful"

    echo "Getting generation..."

    current=$( nixos-rebuild list-generations | grep current )
    wait
    echo $current
else
    echo "Rebuild failed"
    cat nixos-switch.log | grep --color error
    false
fi



# Get current generation metadata

#echo "Current generation: $current"

# Commit all changes witih the generation metadata
#git commit -am "$current"

# Back to where you were
#wait
popd > /dev/null 2>&1

echo "Finished"
# Notify all OK!
#notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
