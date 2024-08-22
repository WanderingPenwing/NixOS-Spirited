#!/usr/bin/env bash

# Get the hostname
host_name=$(hostname)

# Define the NixOS directory and system file path
nixos_dir="$HOME/nixos"
system_file="$nixos_dir/system/$host_name.nix"

# Navigate to the NixOS directory
pushd "$nixos_dir" > /dev/null || { echo "Error: Could not navigate to $nixos_dir"; return 1; }

# Attempt to check out the branch
git checkout "${host_name}-config" || { echo "Error: Failed to check out branch ${host_name}-config"; popd > /dev/null; return 1; }

# Open the specific system configuration file with micro editor
micro "$system_file" || { echo "Error: Failed to open $system_file"; popd > /dev/null; return 1; }

# Return to the previous directory
popd > /dev/null 2>&1
