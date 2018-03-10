#!/bin/sh
# hive=system
hive=$2
find \
$(find \
$(find \
$(find $1 -maxdepth 1 -type d -iname windows) \
-maxdepth 1 -type d -iname system32) \
-maxdepth 1 -type d -iname config) \
-maxdepth 1 -type f -iname $hive
