#!/bin/sh
set -e
yubikey=5406313
userid=$USER@$HOSTNAME
validtime=+5m
username=tim

ssh-keygen -D "$(brew --prefix opensc)/lib/opensc-pkcs11.so" -s "yubikey-$yubikey.pub" -I "$userid" -O clear -V "$validtime" -n "$username" "$1.pub"
