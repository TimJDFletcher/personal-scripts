#!/bin/sh
#host=192.168.1.123
#kvmurl="qemu+ssh://$host/system"
host=localhost
kvmurl="qemu:///system"
display=$(virsh -c $kvmurl domdisplay $1)

# echo $display ; exit

case $display in
vnc*)
        vncviewer $(echo $display | sed -e 's,vnc://,,g')  &
;;
spice*)
        spicec $(echo $display | sed -e s/localhost/$host/g -e 's,spice://,--host ,g' -e 's,:, --port ,g')  &
;;
*)
        echo Unknown display type or VM not running
;;
esac

