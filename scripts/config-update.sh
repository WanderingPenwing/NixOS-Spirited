#!/usr/bin/env bash

set -euo pipefail
trap 'echo "use git checkout --theirs README.md && git add README.md and then git commit if merge failed"; exit 1' ERR

pushd /home/penwing/nixos/ 

git checkout main
git pull origin main

computer_name=$(cat /home/penwing/nixos/computer_name)

git checkout "$computer_name-config" 

# Save the last commit message
LAST_MSG=$(git log -1 --pretty=%B)

# Reset the branch to the base of main (soft reset keeps changes)
git reset --soft $(git merge-base main HEAD)

# Commit all changes with the last commit message
git commit -m "$LAST_MSG"

git merge main

git checkout main
git merge "$computer_name-config"
git push origin main

git checkout "$computer_name-config" 
