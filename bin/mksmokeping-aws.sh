#!/bin/sh
types="ec2 sqs sdb sns"
targets=" us-east-1 us-west-1 ap-southeast-1 us-west-2 sa-east-1 
eu-west-1 ap-northeast-1 ap-southeast-2"

baseconfig="
+ aws
menu = Amazon Web Services
title = Amazon Web Services

probe = Curl
extraargs = --fail
urlformat = http://%host%/ping/
"

subconfig="
++ %TYPE%%TARGET%
menu = %TYPE%%TARGET%
title = %TYPE% in %TARGET%
host = %TYPE%%TARGET%.amazonaws.com
"

echo "$baseconfig"
for type in $types ; do
	for target in $targets ; do
		echo "$subconfig" | sed -e s/%TYPE%/$type/g -e s/%TARGET%/$target/g
	done
done
