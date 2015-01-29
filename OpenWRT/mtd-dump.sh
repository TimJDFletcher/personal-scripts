#!/bin/sh
partitions=$(cat /proc/mtd | grep ^mtd | cut -d ":" -f 1)
tmpdir=$(mktemp -d)
machine=$(cat /proc/cpuinfo | grep machine | cut -d : -f 2 | tr -d " ")
date=$(date +%Y%m%d%H%M%S)

for partition in $partitions ; do
	dd if=/dev/${partition}ro | gzip -c > ${tmpdir}/${partition}.gz
done

cat /proc/mtd > ${tmpdir}/mtd.map

cd ${tmpdir}

if [ x$machine != x ] ; then
	tar -c -v -z -f ../backup-$machine-$date.tar.gz ./
else
	tar -c -v -z -f ../backup-$date.tar.gz ./
fi

# Tidy up
for partition in $partitions ; do
	rm ${tmpdir}/${partition}.gz
done
rm    ${tmpdir}/mtd.map
rmdir ${tmpdir}
	
