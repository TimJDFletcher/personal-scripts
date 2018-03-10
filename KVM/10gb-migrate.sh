#!/bin/sh
apollo=10.0.7.133
cyclopes=10.0.7.135
titan=10.0.7.137

case $1 in
    evacuate)
	echo "Full host evacuation requested, moving all VMs"
	vms="$(virsh list | grep running | awk '{print $2}')"
	;;
    *)
	vms="$1"
	;;
esac

target=$(eval "echo \$${2}")

for vm in $vms ; do
    echo -n "Migration of $vm started to $target: "
    virsh migrate --live $vm qemu+ssh://$target/system tcp://$target/
done
