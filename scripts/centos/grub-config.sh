#!/bin/bash

cat <<EOF >/etc/default/grub
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="crashkernel=auto rhgb quiet intel_iommu=on iommu=pt vfio_iommu_type1.allow_unsafe_interrupts=1 rdblacklist=nouveau nouveau.modeset=0 net.ifnames=0 biosdevname=0"
GRUB_DISABLE_RECOVERY="true"
EOF

if [ -d /sys/firmware/efi ]; then
    mkdir -p /boot/efi/EFI/centos
    grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
else
    grub2-mkconfig -o /boot/grub2/grub.cfg
fi
