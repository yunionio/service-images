#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

SRC_ROOT=$(readlink -f $(dirname "${BASH_SOURCE[0]}")/..)

PACKER_CONFIG=$(readlink -f $1)

function packer_build() {
    local json_conf=$1
    packer build -force $json_conf
}

packer_build $PACKER_CONFIG
