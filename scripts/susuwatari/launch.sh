#!/usr/bin/env bash

pkill -f "susuwatari-server"

sleep 1

exec -a susuwatari-server bash -c "~/nixos/scripts/susuwatari/server.sh" &

sleep 1
