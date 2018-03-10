#!/bin/sh
scp $HOME/bin/rsync-static root@$1:/usr/bin/rsync
ssh root@$1 "chmod 755 /usr/bin/rsync"

