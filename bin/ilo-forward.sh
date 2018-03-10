#!/bin/sh
target=192.168.1.157
ssh \
-L 1080:$target:443 \
-L 3389:$target:3389 \
-L 17988:$target:17988 \
-L 9300:$target:9300 \
-L 17990:$target:17990 \
-L 3002:$target:3002 \
$*

#-L 22:$target:22 \
#-L 23:$target:23 \
#-L 80:$target:80 \
#-L 443:$target:443 \
