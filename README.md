# Personal Scripts

A collection of personal shell scripts, configuration files, and utilities organized by topic and platform.

## Directory Structure

### `bin/` - General Utilities
Standalone utility scripts for everyday tasks:
- **AWS**: Account management, environment setup
- **Backup**: ZFS backup, BackupPC tools
- **Media**: Audio/video extraction and processing
- **Network**: VPN, tcpdump, connection checking
- **System**: Homebrew updates, DNS flush, GPG/SSH key management

### Platform-Specific

| Directory | Description |
|-----------|-------------|
| `macOS/` | macOS-specific scripts and permission fixes |
| `Linux/` | Kernel tools, Open vSwitch scripts, RAID performance |
| `Windows/` | PowerShell scripts, sysprep configs, Cygwin utilities |
| `Ubuntu/` | Package management, desktop post-install |
| `Debian/` | Chroot setup, Jigdo updates |
| `RedHat/` | RHEL/CentOS post-install and VMware tools |

### Hardware & Embedded

| Directory | Description |
|-----------|-------------|
| `RaspberryPi/` | Raspberry Pi setup, QEMU emulation, RTC configuration |
| `iconnect/` | iConnect device kernel flashing |
| `gPXE/` | PXE boot configurations |

### Networking

| Directory | Description |
|-----------|-------------|
| `Cisco/` | IOS configuration, SSH key deployment, VPN monitoring |
| `OpenWRT/` | Router backup, upgrade, and channel configuration |
| `openssh/` | SSH certificates, key signing scripts |

### Virtualization

| Directory | Description |
|-----------|-------------|
| `KVM/` | QEMU/KVM virtual machine launch scripts |
| `VMWare/` | ESXi management, VMDK creation tools |
| `libvirt/` | Libvirt network and storage XML configs |
| `guestfs/` | Libguestfs image manipulation |

### Storage

| Directory | Description |
|-----------|-------------|
| `ZFS/` | ZFS snapshot backup and pool control |
| `flash-cache/` | Flashcache SSD caching sync |
| `FIO/` | Flexible I/O tester benchmark configs |

### Security

| Directory | Description |
|-----------|-------------|
| `Yubikey/` | YubiKey udev rules, screen lock on removal |
| `Security/` | Security tools and tests |
| `xinetd/` | xinetd service forwarding configs |

### Applications

| Directory | Description |
|-----------|-------------|
| `Torrents/` | Transmission BitTorrent management |
| `Photos/` | RAW conversion, HDR creation, photo backup |
| `Ansible/` | Ansible playbooks and virtualenv setup |
| `GRML/` | GRML live system customization |

## Usage

Most scripts are standalone and can be run directly. Many support environment variable configuration with sensible defaults.

Example:
```bash
# ZFS backup with custom host
ZFS_BACKUP_HOST=myserver.local ./bin/zfs-backup.sh

# Run Raspberry Pi in QEMU
./RaspberryPi/launch-qemu-rpi.sh raspbian.img
```

## Notes

### Legacy Scripts

Some scripts reference deprecated software or older system versions and may need updates:

| Script | Notes |
|--------|-------|
| `Ubuntu/ubuntu-desktop-post-install.sh` | References Medibuntu (defunct), Unity |
| `Ansible/ansible-venv.sh` | Uses Python 2, Ansible 2.2 |
| `macOS/skype-for-business-perms.sh` | Skype for Business is deprecated |
| `guestfs/bare-ubuntu-14.04` | Ubuntu 14.04 is EOL |
| `Windows/sysprep-w7/` | Windows 7 is EOL |

### Platform Requirements

- **macOS scripts**: Tested on macOS, may use Homebrew
- **Linux scripts**: Various distros (Ubuntu, Debian, RHEL, OpenWRT)
- **Virtualization**: Requires QEMU/KVM, libvirt, or VMware

## License

See [LICENSE](LICENSE) for details.
