#!/bin/sh

cat /etc/apt/sources.list | sed -e "s/\# deb/deb/g" > /tmp/sources.list

sudo cp /tmp/sources.list /etc/apt/sources.list

sudo apt-get update
