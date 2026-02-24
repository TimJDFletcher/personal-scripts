#!/bin/sh
set -e
yubikey=$(ykinfo -sq)
userid=$USER@$HOSTNAME
validtime=+370D
username=backuphelper
serial=$(date +%s)

ssh-keygen -D "$(brew --prefix opensc)/lib/opensc-pkcs11.so" -s "yubikey-$yubikey.pub" -I "$userid" -O clear -V "$validtime" -z "$serial" -n "$username" "$1.pub"
