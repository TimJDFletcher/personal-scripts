#!/bin/sh
virt-install \
    --connect qemu:///system \
    --name Windows2012r2 \ 
    --os-type=windows --os-variant=win2k8 \
    --ram 4096 \
    --vcpus=2 --cpuset=auto \
    --controller scsi,model=virtio-scsi \
    --disk path=/dev/fusion/Windows2012r2.template,bus=scsi,format=raw \
    --disk device=cdrom,path=/tmp/SW_DVD9_Windows_Svr_Std_and_DataCtr_2012_R2_64Bit_English_-4_MLF_X19-82891.ISO \
    --disk device=cdrom,path=/tmp/RHEV-toolsSetup_4.0-7.iso \
    --boot cdrom,hd \
    --network=network=external,model=virtio,mac=RANDOM \
    --graphics vnc,port=6000,listen=0.0.0.0,password=oorie4aev5iethaP --noautoconsole 

