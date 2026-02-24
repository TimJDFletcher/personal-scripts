#!/bin/sh
set -e
HOST=argon
IFACE=br-lan
ssh "$HOST" tcpdump -i "$IFACE" -s 0 -l -w - "$@" | dd of="$HOST.dump"
