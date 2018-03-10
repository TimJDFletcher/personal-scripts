#!/bin/bash
files="bmap raw.gz"
image_os=ubuntu-16.04
target_os=rancher
date=$1
host=sa-tim-fletcher@10.44.33.100
bucket="s3://tlrg-ansible-artefacts/bi-cluster-image"

set -x
for file in $files ; do
    ssh $host dd if=/tmp/$image_os-$date.$file bs=1M | aws s3 cp - $bucket/${target_os}-template-${date}.${file}
done
