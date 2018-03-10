#!/bin/sh
libvirttarget=/var/lib/libvirt/images/iso
source=/carbon/archives

for target in $libvirttarget ; do
	sudo mkdir -p $target
	sudo find $target -type l -print0 | sudo xargs -0 --no-run-if-empty rm
	find $source -type f -iname '*.iso' -print0 | xargs -0 --no-run-if-empty -I % sudo ln -s % $target
done

