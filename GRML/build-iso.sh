#!/bin/sh
keyboard=uk
isosource=../grml64-full_testing_latest.iso 
isoout=../grml64-full_testing_latest_sshkeys.iso
bootid=$(7z x -so $isosource conf/bootid.txt 2>/dev/null)
sudo grml2iso -b "config ssh noswraid nodmraid nolvm read-only noeject noprompt noswap nofstab keyboard=$keyboard bootid=$bootid" -c overlay/ -o $isoout $isosource
