#!/bin/sh
host=brutus
vm=$1
virt-viewer -c qemu+ssh://$host/system $vm
