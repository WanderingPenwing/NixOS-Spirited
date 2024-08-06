#!/usr/bin/env bash

kodama -e sh -c "cd /home/penwing/repos/$(ls ~/repos | marukuru -l 15) && nix-shell || exec $SHELL"
