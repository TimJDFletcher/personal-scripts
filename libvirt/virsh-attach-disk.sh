#!/bin/bash
# Taken from https://www.redhat.com/archives/libvirt-users/2012-April/msg00053.html
VM=$1
VDX=$2
DEV=$3
if [ -z "$VDX" ]
then
    # try to find out next available vdx device
    echo "Usage: $0 <vmname> <vdx> <dev>"
    exit 1
fi

XMLFILE=/tmp/virsh-attach-disk.$$.xml
echo "
<disk type='block' device='disk'>
<driver name='qemu' type='raw' cache='none' io='native'/>
<source dev='$DEV'/>
<target dev='$VDX' bus='virtio'/>
</disk>
" >$XMLFILE

echo "About to add the following disk config:"
cat $XMLFILE

echo
echo " # virsh attach-device $VM $XMLFILE --persistent"
echo
echo -n "Apply? [y/n] "
read answer
if [ "$answer" == "y" -o "$answer" == "Y" ]
then
    virsh attach-device $VM $XMLFILE --persistent
else
    echo "Aborted!"
fi
rm -f $XMLFILE
