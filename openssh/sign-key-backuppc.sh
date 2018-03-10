#!/bin/sh
yubikey=$(ykinfo -sq)
userid=$USER@$HOSTNAME
vaildtime=+370D
username=backuphelper
serial=$(date +%s)

ssh-keygen -D $(brew --prefix opensc)/lib/opensc-pkcs11.so -s yubikey-$yubikey.pub -I $userid -O clear -V $vaildtime -z $serial -n $username $1.pub
