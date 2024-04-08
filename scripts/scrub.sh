#!/usr/bin/env bash

echo "Scrubbing..."
sudo nix-collect-garbage --delete-older-than 10d 2>/dev/null | grep "freed"
