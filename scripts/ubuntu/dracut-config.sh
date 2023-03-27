#!/bin/bash -e

apt-get install -y dracut
apt-get install -y initramfs-tools

echo 'add_drivers+="hpsa mptsas mpt2sas mpt3sas megaraid_sas mptspi virtio virtio_ring virtio_pci virtio_scsi virtio_blk vmw_pvscsi smartpqi aacraid nvme nvme_core"' >> /etc/dracut.conf

echo 'hpsa
mptsas
mpt2sas
mpt3sas
megaraid_sas
mptspi
virtio
virtio_ring
virtio_pci
virtio_scsi
virtio_blk
vmw_pvscsi
smartpqi
aacraid
nvme
nvme_core' >> /etc/initramfs-tools/modules

dracut -f
update-initramfs -u
