#!/bin/sh
if [ -z $1 ] ; then
    source=linux
else
    source=$1
fi


dir=/working/cubietruck
builddir=$dir/$source
gitdir=/usr/src/git/$source
boot=boot
kernel=vmlinuz
dtb=sun7i-a20-cubietruck.dtb
bootscript=/working/kernel/bootscr.mainline
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-

export LOADADDR=0x40008000
cd $gitdir
if make O=$builddir -j 5 zImage dtbs modules ; then
    version=$(cat $builddir/include/config/kernel.release)
    installdir=$dir/kernel-$version
    export INSTALL_MOD_PATH=$installdir
    mkdir -p $installdir/$boot
    cp $builddir/arch/arm/boot/dts/$dtb $installdir/$boot/dtb-${version}
    cp $builddir/arch/arm/boot/zImage $installdir/$boot/${kernel}-${version}
    cp $builddir/.config $installdir/$boot/config-${version}
    make O=$builddir modules_install
fi

