#!/bin/bash

set -o xtrace
set -o errexit
set -o pipefail

yum-config-manager --add-repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
yum install --assumeyes wireguard-dkms wireguard-tools

kversion="$(rpm -q kernel | sort --version-sort --reverse | head -n1 | cut -d- -f2-)"
dkms_status="$(dkms status wireguard -k "$kversion" | sort --version-sort --reverse | head -n1)"

if ! echo "$dkms_status" | grep -q installed; then
	dkms_version="$(echo "$dkms_status" | cut -d, -f2 | cut -d: -f1 | tr -c -d '0-9.\n')"
	dkms install -m wireguard -v "$dkms_version" -k "$kversion"
fi
