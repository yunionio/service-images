#!/bin/bash

echo 'add_drivers+="hpsa mptsas mpt2sas mpt3sas megaraid_sas mptspi virtio virtio_ring virtio_pci virtio_scsi virtio_blk vmw_pvscsi"' >> /etc/dracut.conf
dracut -f

cat <<EOF >/etc/default/grub
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="crashkernel=auto rhgb quiet intel_iommu=on iommu=pt vfio_iommu_type1.allow_unsafe_interrupts=1 rdblacklist=nouveau nouveau.modeset=0 net.ifnames=0 biosdevname=0"
GRUB_DISABLE_RECOVERY="true"
EOF

grub2-mkconfig -o /boot/grub2/grub.cfg
