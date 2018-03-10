#!/bin/sh
echo -n "Syncing all disks: "
echo s | sudo tee /proc/sysrq-trigger
sleep 10
echo done

echo -n "Unmounting all disks: "
echo u | sudo tee /proc/sysrq-trigger
sleep 10
echo done

echo -n "Rebooting: "
echo b | sudo tee /proc/sysrq-trigger
echo done
