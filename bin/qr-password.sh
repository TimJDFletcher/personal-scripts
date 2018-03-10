#!/bin/bash -e 
if [ -z $1 ] ; then
    LENGTH=16
else
    LENGTH=$1
fi
password=$(pwgen -1 $LENGTH)
echo $password | pbcopy 
echo $password | qrencode -t ANSI256
echo The password is $password copied the pasteboard too
