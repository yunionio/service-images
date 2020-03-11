#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <user@host>"
    exit 1
fi

rsync -avz --progress $1:/opt/yunion/*.sh rootfs/opt/yunion
rsync -avz --progress $1:/etc/init.d/yunion rootfs/etc/init.d/yunion
rsync -avz --progress $1:/etc/default/grub rootfs/etc/default/grub
rsync -avz --progress $1:/etc/sysctl.conf rootfs/etc/sysctl.conf
