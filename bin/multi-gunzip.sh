#!/bin/bash
set -e
maxloop=100
loop=0
file="$1"
while file "${file}" | grep -q "gzip compressed data" ; do
    temp=$(mktemp)
    gzip -dc "${file}" > ${temp}
    mv ${temp} "${file}"
    loop=$((loop+1))
    if [ $loop -gt $maxloop ] ; then
        Failed to uncompress file after $loop loops
        exit 1
    fi
done

echo decompressed $file after $loop loops
