#!/bin/sh
nfsbaseimage='/carbon/diskimages/Virtual Machines/Microsoft/WindowsXP-SP3-base.qcow2'
baseimage='WindowsXP-SP3-base.qcow2'
target=WindowsXP-SP3.img
dir=/var/lib/libvirt/images

sudo rm -i $dir/$target
sudo qemu-img create -f qcow2 -b "$dir/$baseimage" "$dir/$target"

