#!/bin/bash
TARGET=$1
find $1 -type d -name '.git' | while read dir ; do 
    sh -c "cd $dir/../ && echo \"\nGIT STATUS IN ${dir//\.git/}\" && git status -s"
done
