#!/bin/bash
mkdir -p ${LOGNAME}

# Grab serial number of connected Yubikey
yk_serial=$(gpg --batch --card-status| grep "^Serial number" | awk '{print $NF}')

#gen serials file if not existing
touch ${LOGNAME}/yubikeyserialnumber.txt

#check if yubikey serial already on file and if not record it
if ! grep -q $yk_serial ${LOGNAME}/yubikeyserialnumber.txt ; then
    echo $yk_serial >> ${LOGNAME}/yubikeyserialnumber.txt
fi

#Export public key for connected yubikey ASCI
gpg --batch --export --armor --output ${LOGNAME}/pubkey-${yk_serial}.asc $(gpg --batch --card-status | grep "^General key info" | cut -d " " -f 6 | cut -d "/" -f 2)
#Export public key as binary blob
gpg --batch --export $(gpg --batch --card-status | grep "^General key info" | cut -d " " -f 6 | cut -d "/" -f 2) > ${LOGNAME}/pubkey-${yk_serial}.pgp.bin
#Export pubkey as base64 encoded binary
gpg --batch --export $(gpg --batch --card-status | grep "^General key info" | cut -d " " -f 6 | cut -d "/" -f 2) | base64 -w 0 > ${LOGNAME}/pubkey-${yk_serial}.pgp.bin.base64

# Export the public ssh key, assumes working gpg-agent
ssh-add -L | grep "${yk_serial}"$ > ${LOGNAME}/ssh-key-${yk_serial}.pub
