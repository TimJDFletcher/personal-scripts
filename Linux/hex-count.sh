#!/bin/sh
#
# hexcount -  POSIX Shell script to count from $1 to $2 in hex,
#             separated by ";" and with the precision set to the
#             maximum digits of $1 and $2.
# Usage:      hexcount lo hi
# Example:    hexcount FFF 1200

from=$1 to=$2
if test "${#from}" -gt "${#to}"; then
    format="%0${#from}X "
else
    format="%0${#to}X "
fi
from=$(printf '%d' "0x$from") to=$(printf '%d' "0x$to")
while test "$from" -le "$to"; do
    printf "$format" "$from"
    from=$((from+1))
done
printf '\n'
