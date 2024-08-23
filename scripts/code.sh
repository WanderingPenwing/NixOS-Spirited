#!/usr/bin/env bash

kodama -e sh -c 'cd /home/penwing/repos/$(ls ~/repos | marukuru -l 15) && \
if [ -f shell.nix ]; then \
    nix-shell; \
elif [ -f flake.nix ]; then \
    nix develop; \
else \
    exec $SHELL; \
fi;'
