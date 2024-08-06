#!/usr/bin/env bash

nix-shell -p "$1" --run "$1"
