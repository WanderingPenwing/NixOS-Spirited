#!/usr/bin/env bash

echo "Trying to rebuild..."

set -e

# cd to your config dir
pushd /home/penwing/nixos/ > /dev/null 2>&1

computer_name=$(cat /home/penwing/nixos/computer_name)

git checkout "$computer_name-config" 

if [ ! $# -eq 0 ]; then
	echo "# Kamaji *" > README.md

	git add .
	git commit -m "NixOS rebuild: forced try"

	echo "# Kamaji" > README.md
else
	git diff -U0
	
	echo "# Kamaji" > README.md

	git add .
	git commit -m "NixOS rebuild: try"
fi



echo ""
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

cat <<EOF > README.md
# Kamaji

This is my config for nix os, written in the kamaji.nix (name of my computer)

# Usage

copy (and modify if needed) the etc-configuration.nix to /etc/nixos/configuration.nix

then use the rebuild script to rebuild the nixos, and if successful it will commit,
with the number of the generation.
  
Generation: $current
EOF

git add .

# Commit all changes with the generation metadata
git commit -m "NixOS rebuild: Generation $current"

echo "Setting up..."
betterlockscreen -u ~/nixos/wallpapers/main.png --fx > /dev/null 2>&1

popd > /dev/null 2>&1

echo "Finished"
