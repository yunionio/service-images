#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

SRC_ROOT=$(readlink -f $(dirname "${BASH_SOURCE[0]}")/..)
ISO_SERVER="https://iso.yunion.cn/beta"
CACHE_DIR="$SRC_ROOT/_cache"
ISO_MNT_POINT="/mnt"
CONTRIB_DIR="$SRC_ROOT/contrib"

function generate_iso_url() {
    local iso=$1
    echo "$ISO_SERVER/$iso"
}

function get_remote_iso_md5() {
    local iso_md5_url="$1.md5sum"
    echo $(curl --silent $iso_md5_url | cut -d' ' -f1)
}

function generate_iso_basename() {
    local version=$1
    echo "yunion-$version.iso"
}

function download_iso() {
    local version=$1
    local output_dir=$2
    local iso_name=$(generate_iso_basename $version)
    local url=$(generate_iso_url $iso_name)
    (
    if [ ! -d $output_dir ]; then
        mkdir -p $output_dir
    fi
    cd $output_dir
    local remote_iso_md5sum=$(get_remote_iso_md5 $url)
    if [ -f "./$iso_name" ]; then
        local iso_md5sum=$(md5sum ./$iso_name | cut -d' ' -f1)
        if [ "$iso_md5sum" -ne "$remote_iso_md5sum" ]; then
            rm -f ./$iso_name
            curl -OL $url
        fi
    else
        curl -OL $url
    fi
    )
    echo "$output_dir/$iso_name"
}

function uncompress_to() {
    local src=$1
    local dst=$2
    tar -xf $src -C $dst
}

function prepare_env() {
    local iso_version=$1
    local iso_path=$(download_iso $iso_version $CACHE_DIR)
    mkdir -p $CONTRIB_DIR
    if mountpoint -q $ISO_MNT_POINT; then
        sudo umount $ISO_MNT_POINT
    fi

    sudo mount $iso_path $ISO_MNT_POINT
    local cloud_src=$(find "$ISO_MNT_POINT/cloud" -type f -name "*.tar.gz")
    local yunionsetup_src=$(find "$ISO_MNT_POINT/yunionsetup" -type f -name "*.tar.gz")
    # copy src code to /opt/{cloud,yunionsetup}
    uncompress_to $cloud_src $CONTRIB_DIR
    uncompress_to $yunionsetup_src $CONTRIB_DIR

    # sync file to /opt/yunion/upgrade
    local upgrade_dir=$CONTRIB_DIR/upgrade
    rm -rf $upgrade_dir
    mkdir -p $upgrade_dir
    rsync -avP $ISO_MNT_POINT/{upgrade.sh,downloader.sh,version*} $upgrade_dir

    # sync upgrade rpms
    local repo=$CONTRIB_DIR/repo
    rm -rf $repo
    mkdir -p $repo
    rsync -avP $ISO_MNT_POINT/rpms/updates/{yunion-sdnagent*,yunion-kube-agent*,yunion-autoupdate*,yunion-host*} $repo

    sudo umount $ISO_MNT_POINT
}

prepare_env $1
