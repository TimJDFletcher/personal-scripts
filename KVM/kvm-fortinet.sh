#!/bin/sh
emu=/usr/bin/qemu-system-x86_64
#emu=/usr/src/git/qemu/x86_64-softmmu/qemu-system-x86_64
scsi=lsi
#bios=/usr/src/git/seabios/out/bios.bin

$emu -net none -machine accel=kvm:tcg -name FortiGate-VM -M pc -m 512 \
-device $scsi,id=scsi0,bus=pci.0,addr=0x4 \
-drive file=/tmp/fortios.qcow2,if=none,id=drive-scsi0-0-0,format=qcow2 \
-device scsi-hd,bus=scsi0.0,scsi-id=0,drive=drive-scsi0-0-0,id=scsi0-0-0,bootindex=1 \
-vga cirrus # -kernel /tmp/flatkc.smp -initrd /tmp/rootfs.gz \
# -append "ro panic=60 endbase=0xA0000 console=tty0 root=/dev/ram0 ramdisk_size=65536 debug"
# -bios $bios
