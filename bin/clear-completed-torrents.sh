#!/bin/sh
for i in $(transmission-remote -l | awk '{print $1,$2}' | grep  100% | awk '{print $1}' ); do 
	transmission-remote -t $i -r
done
