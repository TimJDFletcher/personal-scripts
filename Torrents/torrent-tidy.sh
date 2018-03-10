#!/bin/sh
find /archives/unsorted/transmission -mtime +14 -type f -print0 |\
xargs -0 rm
