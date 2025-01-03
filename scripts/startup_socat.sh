#!/usr/bin/env bash

echo "started" >> /tmp/wake.log
socat TCP-LISTEN:1780,fork EXEC:/home/penwing/nixos/scripts/wakeonlan.sh &
