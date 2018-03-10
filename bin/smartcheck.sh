#!/bin/sh
for i in a b c d e ; do 
	sudo smartctl -l error /dev/sd$i
done

