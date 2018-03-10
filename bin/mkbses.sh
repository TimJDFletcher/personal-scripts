#!/bin/bash
type=es-metrics
for host in $(seq 1 4) ; do
  cat <<EOF > bihost-0${host}-${type}
ansible_host: ${base_ip}.${vm_ip}
libvirt_vm_host: bihost-0${host}
node_type: ${type}
node_mac_address: 52:54:00:$(echo bihost-0${host}-${type}|md5|sed 's/^\(..\)\(..\)\(..\).*$/02:\1:\2/')
EOF
done
