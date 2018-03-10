#!/bin/sh
key=yubikey.pub
cat $HOME/.ssh/$key | ssh root@$1 "cat >> /etc/ssh/keys-root/authorized_keys"

