#!/usr/bin/env bash

echo "--" >> /tmp/socat.log
wakeonlan c0:7c:d1:fb:c9:86 2>&1 >> /tmp/socat.log

echo "sent"
