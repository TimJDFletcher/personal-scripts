#!/bin/sh
temp_key=$(mktemp $HOME/key.XXXXXX)
cp $1 $temp_key
chmod 400 $temp_key
ssh-add $temp_key
rm -f $temp_key
