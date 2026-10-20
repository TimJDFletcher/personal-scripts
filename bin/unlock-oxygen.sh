#!/bin/bash
set -eu -o pipefail

host=oxygen-initramfs

_print_password ()
{
    gopass show --password disks/oxygen/root
}

_ensure_gopass_latest ()
{
    gopass sync --store root
}

unlock_remote_luks ()
{
    _print_password | ssh -o HostKeyAlgorithms=+ecdsa-sha2-nistp256,rsa-sha2-256 $host cryptroot-unlock
}

unlock_remote_luks
