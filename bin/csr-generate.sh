#!/bin/bash
set -e
export SSL_PASS=$(pwgen -1 32)

CN="$1"
EMAIL="noc@laterooms.com"
FILENAME=$(echo "$1" | sed -e 's/\./_/g' -e 's/\*/star/g')
SUBJ="/O=Late Rooms Limited\
/businessCategory=Private\
/serialNumber=03816947\
/streetAddress=The Peninsula Building\
/L=Manchester\
/ST=Greater Manchester\
/C=GB\
/CN=$CN\
/emailAddress=$EMAIL"

openssl req \
    -new \
    -newkey rsa:4096 \
    -sha256 \
    -passout env:SSL_PASS \
    -out ${FILENAME}.csr \
    -keyout ${FILENAME}.key \
    -subj "${SUBJ}"

echo -n "Testing new key and passphrase: "
openssl rsa \
    -passin env:SSL_PASS \
    -in ${FILENAME}.key \
    -check \
    -noout 

echo CSR is in the file ${FILENAME}.csr
echo Key is in the file ${FILENAME}.key
echo Key password is: $SSL_PASS
unset SSL_PASS
