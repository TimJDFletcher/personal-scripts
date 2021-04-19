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
    _print_password | ssh $host cryptroot-unlock
}

unlock_remote_luks
