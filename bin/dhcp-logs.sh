#!/bin/bash
tail --silent -n 40 -f /var/log/remote/$(date +%Y/%m/%d)/192.168.1.{1,5}.log | egrep -v named\|imuxsock

