#!/bin/bash

set -e
set -x

yun::yum::repoinstall() {
    for i in "$@"; do
        yum --disablerepo='*' --enablerepo='yunion*' install -y "$i" || {
            echo "[yun::yum::repoinstall] failed to install $i. trying online install... "
            sudo yum install -y "$i"
        }
    done
}

pkgs_baremetal=(
    python-six
    pythonlibs-controller
    pythonlibs-pth
    net-tools
    ipmitool
    yunion-baremetal-agent
)

pkgs_host=(
    chntpw
    #docker-ce
    #docker-ce-selinux
    #kubeadm
    #kubectl
    #cri-tools
    #kubelet
    #kubernetes-cni
    dosfstools
    ethtool
    fetchclient
    fuse
    fuse-devel
    fuse-libs
    gdisk
    gettext
    libaio
    host-image
    jq
    kapacitor
    libusb
    lvm2
    lxcfs
    lz4
    nc
    ntfs-3g_ntfsprogs
    oniguruma
    parted
    pciutils
    python-rados
    python-rbd
    python-six
    pythonlibs-controller
    pythonlibs-host
    pythonlibs-pth
    spice
    spice-protocol
    sshpass
    sysstat
    tcpdump
    telegraf
    usbredir
    vmware-vddk
    xfsprogs
    yunion-qemu-2.12.1
    zerofree
    yunion-host
)

yun::yum::repoinstall "${pkgs_host[@]}"
yun::yum::repoinstall "${pkgs_baremetal[@]}"

yum install -y \
    kernel-3.10.0-862.14.4.el7.yn20190116 \
    kernel-devel-3.10.0-862.14.4.el7.yn20190116 \
    kernel-headers-3.10.0-862.14.4.el7.yn20190116 \
    kmod-openvswitch \
    openvswitch
