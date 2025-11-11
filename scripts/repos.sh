#!/usr/bin/env bash

kodama -e sh -c 'cd /home/penwing/repos/$(ls ~/repos | marukuru -c -l 15 -bw 6) && \
if [ -f shell.nix ]; then \
    nix-shell --run $SHELL; \
elif [ -f flake.nix ]; then \
    nix develop --command $SHELL; \
else \
    exec $SHELL; \
fi;'
