#!/bin/sh
LATEST=$(find $HOME/bin/ -iname jbidwatch\*\.jar | sort -n | tail -n 1)
java -Xmx512m -jar $LATEST
