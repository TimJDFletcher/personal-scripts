#!/bin/sh
TEMP_FILE=$(mktemp)
openssl x509 -in $1 -pubkey -noout > $TEMP_FILE 
SSH_KEY=$(ssh-keygen -i -m PKCS8 -f $TEMP_FILE)
echo $SSH_KEY $(basename $1)
rm -f $TEMP_FILE
