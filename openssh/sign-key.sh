#!/bin/sh
yubikey=5406313
userid=$USER@$HOSTNAME
vaildtime=+5m
username=tim

ssh-keygen -D $(brew --prefix opensc)/lib/opensc-pkcs11.so -s yubikey-$yubikey.pub -I $userid -O clear -V $vaildtime -n $username $1.pub
