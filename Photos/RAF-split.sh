#!/bin/sh
for type in RAF JPG ; do
    mkdir -p $type
    find ./ -type f -name '*.'$type -print0| xargs -0 -I % mv % $type
done
