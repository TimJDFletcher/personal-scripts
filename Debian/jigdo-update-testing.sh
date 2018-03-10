#!/bin/bash
# Script to update an existing iso to the latest version via Jigdo
url=http://ftp.heanet.ie/mirrors/ftp.debian.org/debian-cd-weekly/amd64/jigdo-dvd
basename=debian-testing-amd64-DVD-1
target=/working/Debian

for file in iso template jigdo ; do
	mv ${target}/${basename}.${file} ${target}/${basename}.${file}.old
done

for file in template jigdo ; do
	wget ${url}/${basename}.${file} -O ${target}/${basename}.${file}
done

sudo mkdir -p /run/jigdo/${basename}
sudo mount -o loop ${target}/${basename}.iso.old /run/jigdo/${basename}

cd ${target}
jigdo-lite --scan /run/jigdo/${basename} ${basename}.jigdo
sudo umount /run/jigdo/${basename}
sudo rmdir -p /run/jigdo/${basename}
