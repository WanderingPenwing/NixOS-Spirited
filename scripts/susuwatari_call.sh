#!/usr/bin/env bash

susu_id=$(pgrep -f susuwatari)

kill -SIGUSR1 $susu_id
