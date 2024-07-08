#!/usr/bin/env bash

# Define the path and pack name
resourcepacks_path="/home/penwing/.local/share/PrismLauncher/instances/1.21/.minecraft/resourcepacks/"
pack=${PWD##*/}          # to assign to a variable
pack=${pack:-/} 

#pack="test"

# Use command substitution to store the output of the find command in a variable
previous_packs=$(find "$resourcepacks_path" -type f -name "${pack}*.zip" -print)

# Initialize a variable to store the largest version number
max_version=0

# Process each found pack to extract and compare the version numbers
for pack_file in $previous_packs; do
    # Extract the version number using parameter expansion and regex
    version=$(basename "$pack_file" | sed 's/.zip//' | sed 's/.*_v//')
    
    # Compare the extracted version number with the current max_version
    if [[ "$version" -gt "$max_version" ]]; then
        max_version="$version"
    fi
done

((max_version += 1))
# Print the largest version number
echo "The new version is : ${pack}_v${max_version}"

zip -qr "$resourcepacks_path${pack}_v${max_version}.zip" .
