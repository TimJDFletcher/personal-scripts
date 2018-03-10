#!/bin/sh
FSPOT_DIR=/exports/photos/f-spot
cd $FSPOT_DIR
for dir in * ; do 
    size=$(du -sh $dir | awk '{print $1}')
    filecount=$(find $dir -type f | wc -l)
    echo "$dir $filecount $size"
done
cd -
