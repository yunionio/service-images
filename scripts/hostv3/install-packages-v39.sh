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
    autogen-libopts
    bash-completion
    boost-iostreams
    boost-random
    boost-system
    boost-thread
    curl
    libaio
    libbasicobjects
    libcollection
    libini_config
    libjpeg-turbo
    libnfsidmap
    libogg
    libpath_utils
    libpcap
    librados2
    librbd1
    libref_array
    libselinux-python3
    libtirpc
    libusb
    libusbx
    libverto-libevent
    lm_sensors-libs
    lvm2
    nc
    ntp
    ntpdate
    nfs-utils
    nmap-ncat
    yunion-fetcherfs
    fuse
    gssproxy
    fuse-devel
    fuse-libs
    oniguruma
    parallel
    pciutils
    pixman
    quota
    quota-nls
    rpcbind
    rsync
    socat
    spice
    spice-protocol
    sysstat
    tcp_wrappers
    unbound
    unbound-libs
    tcpdump
    usbutils
    wget
    usbredir
    yunion-qemu-4.2.0
    yunion-ovmfrpm
    htop
    yunion-ocadm
    yunion-executor

    docker-ce
    docker-ce-cli
    containerd.io
    container-selinux
    cri-tools

    bridge-utils
    ipvsadm
    ipset
    keyutils
    conntrack-tools
    jq
    kubeadm-1.15.12-0
    kubectl-1.15.12-0
    kubelet-1.15.12-0
    kubernetes-cni
    celt051
    ceph-common
)

yun::yum::repoinstall "${pkgs_host[@]}"
yun::yum::repoinstall "${pkgs_baremetal[@]}"

yum install -y \
    kernel-devel-3.10.0-1160.53.1.el7.yn20220518.x86_64 \
    kernel-headers-3.10.0-1160.53.1.el7.yn20220518.x86_64 \
    kernel-3.10.0-1160.53.1.el7.yn20220518.x86_64 \
    kmod \
    kmod-openvswitch \
    openvswitch
