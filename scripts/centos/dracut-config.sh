#!/bin/bash

echo 'add_drivers+="hpsa mptsas mpt2sas mpt3sas megaraid_sas mptspi virtio virtio_ring virtio_pci virtio_scsi virtio_blk vmw_pvscsi smartpqi aacraid"' >> /etc/dracut.conf
dracut -f
