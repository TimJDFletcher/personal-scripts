#!/bin/sh
versions="alternate desktop server"
archs="amd64 i386"
shortversion="11.04"
baseurl="http://releases.ubuntu.com"

for version in $versions ; do
    for arch in $archs ; do
        $wget $baseurl/$shortversion/$longversion-$version-$arch.iso.torrent
    done
done
