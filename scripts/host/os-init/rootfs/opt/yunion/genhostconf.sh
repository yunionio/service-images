#!/bin/bash

IFNAME=$(ifconfig | grep ^eth | head -n 1 | awk 'BEGIN{FS=":"}{print $1}')
ADDR=$(ifconfig $IFNAME | grep "inet " | awk '{print $2}')
HOSTNAME=$(hostname)
TIME=$(date)

replace() {
  local FILE=$1
  local PATTERN=$2
  local REPLACE=$3
  sed -i '/'"$PATTERN"'/c\'"$REPLACE"' # '"$TIME"'' $FILE
}

if [ -z "$ADDR" ]; then
    echo "Network already configured"
    exit 0
fi

if [ -e /etc/sysconfig/yunionauth ]; then
  . /etc/sysconfig/yunionauth
fi

CONF=/etc/yunion/host.conf
BRNAME=${YUNION_MASTER_BRIDGE:-br0}
replace $CONF '^networks ' "networks = ['$IFNAME/$BRNAME/$ADDR']"
replace $CONF '^hostname ' "hostname = '$HOSTNAME'"
if [ -n "$YUNION_REGION" ]; then
    replace $CONF '^region ' "region = '$YUNION_REGION'"
fi
if [ -n "$YUNION_KEYSTONE" ]; then
    replace $CONF '^auth_uri ' "auth_uri = '$YUNION_KEYSTONE'"
fi
if [ -n "$YUNION_HOST_ADMIN" ]; then
    replace $CONF '^admin_user ' "admin_user = '$YUNION_HOST_ADMIN'"
fi
if [ -n "$YUNION_HOST_PASSWORD" ]; then
    replace $CONF '^admin_password ' "admin_password = '$YUNION_HOST_PASSWORD'"
fi
if [ -n "$YUNION_HOST_PROJECT" ]; then
    replace $CONF '^admin_tenant_name ' "admin_tenant_name = '$YUNION_HOST_PROJECT'"
fi
if [ "$YUNION_KUBELET_ENABLE" == "yes" ]; then
    replace $CONF '^host_type ' "host_type = 'kubelet'"
fi

for d in disks iso_cache logs run servers
do
    mkdir -p /opt/cloud/workspace/$d
done

cp -f /opt/yunion/systemd/*.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable yunion-host
systemctl start yunion-host
