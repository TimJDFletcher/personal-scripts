#!/bin/sh
password=foobar
sudo hdparm --user-master u --security-set-pass $password /dev/sd$1
sudo hdparm --user-master u --security-erase $password /dev/sd$1
