#!/bin/bash
set -eu -o pipefail

host=root@192.168.8.2

_print_password ()
{
    gopass show disks/oxygen/root
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
