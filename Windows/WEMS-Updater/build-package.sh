#!/bin/sh
plinkURL=http://the.earth.li/~sgtatham/putty/latest/x86/plink.exe
plink=plink.exe

moduleURL=http://192.168.1.10/serial/aserial_test.ko
module=aserial_test.ko

agentURL=
agent=awd_agent

initscript=persistAwd

wget $plinkURL  -O $plink
wget $moduleURL -O $module
#wget $agentURL -O $agent

for file in $module $agent $initscript ; do
    md5sum $file > ${file}.md5
done

zip -r $HOME/WEMS-Updater.zip ./
