#!/bin/sh
filename=$1
bytesize=$(du --apparent-size --bytes $filename | awk '{print $1}')
blocksize=512
disksize=$((bytesize/blocksize))
CID=$(dd if=/dev/urandom bs=1k count=1 2>/dev/null| crc32 /dev/stdin)
# CID=$(crc32 $filename)
HWversion=10
Heads=255
Sectors=63
Cylinders=$((bytesize/Heads/Sectors))

cat << EOF
# Disk DescriptorFile
version=1
encoding="UTF-8"
CID=$CID
parentCID=ffffffff
isNativeSnapshot="no"
createType="vmfs"

# Extent description
RW $disksize VMFS "$filename"

# The Disk Data Base 
#DDB

ddb.adapterType = "lsilogic"
ddb.deletable = "true"
ddb.geometry.cylinders = "$Cylinders"
ddb.geometry.heads = "$Heads"
ddb.geometry.sectors = "$Sectors"
ddb.thinProvisioned = "1"
ddb.virtualHWVersion = "$HWversion"
EOF
