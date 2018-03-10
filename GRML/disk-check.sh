#!/bin/sh
badblocks -s -w -v -b 4096 /dev/sd$1
