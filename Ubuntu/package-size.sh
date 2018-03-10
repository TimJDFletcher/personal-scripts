#!/bin/sh
dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n

