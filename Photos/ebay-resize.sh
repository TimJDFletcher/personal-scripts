#!/bin/sh
smallsize=480
largesize=1280
mkdir -p $largesize $smallsize
IFS="
"
types="
png
jpg
"

for type in $types ; do
	files=$(find ./ -maxdepth 1 -iname \*.${type} )
	for file in $files ; do
		convert $file -resize $smallsize $smallsize/$(basename $file .${type} ).jpg
		convert $file -resize $largesize $largesize/$(basename $file .${type} ).jpg
	done
done
