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
    epel-release
    libaio
    libusb
    lvm2
    nc
    ntp
    yunion-fetcherfs
    fuse
    fuse-devel
    fuse-libs
    oniguruma
    pciutils
    spice
    spice-protocol
    sysstat
    tcpdump
    usbredir
    yunion-qemu-2.12.1
    yunion-ocadm
    yunion-executor

    docker-ce
    docker-ce-cli
    containerd.io

    bridge-utils
    ipvsadm
    conntrack-tools
    jq
    kubelet
    kubectl
    kubeadm
)

yun::yum::repoinstall "${pkgs_host[@]}"
yun::yum::repoinstall "${pkgs_baremetal[@]}"

yum install -y \
    kernel-3.10.0-1160.6.1.el7.yn20201125 \
    kernel-devel-3.10.0-1160.6.1.el7.yn20201125 \
    kernel-headers-3.10.0-1160.6.1.el7.yn20201125 \
    kmod-openvswitch \
    openvswitch
