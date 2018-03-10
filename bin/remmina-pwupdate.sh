#!/bin/sh
cd ~/.remmina
ls -t `grep -li "username=timfletcher" *.remmina` | grep -m 2 "^.*$" | xargs sed -nr 's/(password=)(.*)/\2/p' | sed -r 's/([\x24\x27-\x2B\x2E\x2F\x3F\x5B-\x5E\x7B\x7C\x7D])/\\\\\1/g' | xargs bash -c 'sed -ri s/$1/$0/ *.remmina' 
