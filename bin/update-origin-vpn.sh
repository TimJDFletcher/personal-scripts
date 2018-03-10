#!/bin/bash
for dir in * ; do 
    cd $dir 
    if git remote get-url origin | grep -q carbon/ ; then 
        newurl=$(git remote get-url origin| sed -e s,carbon/,carbon-vpn/,g)
        git remote remove origin
        git remote add origin $newurl
    fi
    cd - 
done
