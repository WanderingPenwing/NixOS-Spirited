#!/usr/bin/env bash
rm -rf $HOME/nixos

git clone https://github.com/WanderingPenwing/NixOS-Spirited $HOME/nixos --depth 1

micro $HOME/nixos/computer_name
