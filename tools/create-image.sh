#!/bin/bash

set -o errexit
#set -o nounset

IMG_ROOT=$(dirname "${BASH_SOURCE[0]}")/..
IMG_PATH=$(readlink -f $1)
NBD_DEV=$2
if [ -z "$NBD_DEV" ]; then
    NBD_DEV=/dev/nbd0
fi

sudo modprobe nbd

function zerofree_dev() {
    local dev=$1
    echo "Start zerofree dev $dev ..."
    sudo zerofree -v "$dev" || true
    echo "Finish zerofree"
}

function nbd_connect() {
    local nbd_dev=$1
    local img=$2
    sudo qemu-nbd -c $nbd_dev $img
}

function nbd_disconnect() {
    local nbd_dev=$1
    sudo qemu-nbd -d $nbd_dev
}

function img_convert() {
    local img=$1
    local out_img="$1.qcow2"
    echo "Convert $img to $out_img ..."
    qemu-img convert -O qcow2 -c $img $out_img
    echo "Convert finish"
}

function img_create() {
    local img=$1
    local nbd_dev=$2
    nbd_connect $nbd_dev $img
    local parts=$(find /dev | grep "${nbd_dev}p")
    for p in $parts; do
        zerofree_dev $p
    done
    nbd_disconnect $nbd_dev
    img_convert $img
}

function exit_handle() {
    echo "Handle exit"
    nbd_disconnect $NBD_DEV
}

trap exit_handle EXIT

img_create $IMG_PATH $NBD_DEV
