#!/bin/bash

. /etc/sysconfig/yunionauth

interface_ip() {
    ip address show dev $1 | grep "inet " | awk '{print $2}' | cut -d/ -f1 | head -n 1
}

INF=
MAX_WAIT=30
WAITED=0

while [ -z "$INF" ] && [ "$WAITED" -lt "$MAX_WAIT" ]
do
    WAITED=$((WAITED+1))
    sleep 1
    for inf in $(ls /sys/class/net/)
    do
        if [ $inf != "lo" ] && [ -d /sys/class/net/$inf ]; then
            IP=$(interface_ip $inf)
            if [ -n "$IP" ]; then
                INF=$inf
                break
            fi
        fi
    done
done

if [ -z "$INF" ]; then
    echo "No interface has IP..."
    exit 1
else
    echo "$INF has IP ..."
fi

echo "CLOUD_DIR=/opt/cloud
INTERFACE=$INF
MASTER_BRIDGE=br0
REGION=$YUNION_REGION
HOST_NAME=$YUNION_HOST_NAME
HOST_ONLY=yes
COMPONENTS=(HOST)
UPDATE_REPO=/opt/repo
ENABLE_SSL=$YUNION_KEYSTONE_USE_SSL
KEYSTONE_ADMIN_PORT=$YUNION_KEYSTONE_PORT
KEYSTONE_HOST=$YUNION_KEYSTONE_HOST
HOST_ADMIN_PASS=$YUNION_HOST_PASSWORD
HOST_ADMIN_USER=$YUNION_HOST_ADMIN" > /opt/yunionsetup/vars

sudo chown -R yunion:yunion /opt/cloud/workspace/

for d in disks iso_cache logs run servers
do
    mkdir -p /opt/cloud/workspace/$d
done

cd /opt/yunionsetup

./setup.sh

UPGRADE_DIR=/opt/yunion/upgrade
sudo ./scripts/all_setup.sh
