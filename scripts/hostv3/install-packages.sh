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
    net-tools
)

pkgs_host=(
    docker-ce-18.09.1
    docker-ce-cli-18.09.1
    containerd.io
    bridge-utils
    ipvsadm
    jq
    conntrack-tools
    kubeadm-1.15.8-0
    kubectl-1.15.8-0
    kubelet-1.15.8-0
    yunion-ocadm
    cri-tools
    kubernetes-cni
    fetchclient
    fuse
    fuse-devel
    fuse-libs
    oniguruma
    pciutils
    spice
    spice-protocol
    sysstat
    tcpdump
    telegraf
    usbredir
    yunion-qemu-2.12.1
    yunion-executor-server
    gdisk
    gettext
    libaio
    libusb
    lvm2
    lz4
    nc
    parted
)

yun::yum::repoinstall "${pkgs_host[@]}"
yun::yum::repoinstall "${pkgs_baremetal[@]}"

yum install -y \
    kernel-3.10.0-1062.4.3.el7.yn20191203 \
    kernel-devel-3.10.0-1062.4.3.el7.yn20191203 \
    kernel-headers-3.10.0-1062.4.3.el7.yn20191203 \
    kmod-openvswitch \
    openvswitch
