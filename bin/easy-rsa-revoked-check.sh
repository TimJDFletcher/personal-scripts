#!/bin/bash
revoked_file=$(mktemp /tmp/revoked.XXXXXXXX)
from=$(printf '%d' "0x01")
to=$(printf '%d' "$((0x$(cat keys/serial)-1))")
format="%0${#to}X"
cat keys/ca.crt keys/crl.pem > $revoked_file

while test "$from" -le "$to"; do
    id="$(printf "$format" "$from")"
    if openssl verify -crl_check -CAfile $revoked_file keys/${id}.pem >/dev/null 2>&1 ; then
        printf "Active Cert: "
    else
        printf "Revoked Cert: "
    fi
    openssl x509 -noout -subject -in keys/${id}.pem
    from=$((from+1))
done

rm $revoked_file
