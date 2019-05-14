#!/bin/bash

SLAVE1="$1" # e.g eth0
SLAVE2="$2" # e.g. eth1

if [ -z "$SLAVE1" ] || [ -z "$SLAVE2" ]; then
    echo "please specify slave interfaces..."
    echo "Usage: $0 <inf1> <inf2>"
    exit 1
fi

if [ ! -e /sys/class/net/$SLAVE1 ]; then
    echo "$SLAVE1 does not exist!"
    exit 1
fi

if [ ! -e /sys/class/net/$SLAVE2 ]; then
    echo "$SLAVE2 does not exist!"
    exit 1
fi


MAC1=$(cat /sys/class/net/$SLAVE1/address)
MAC2=$(cat /sys/class/net/$SLAVE2/address)

DIR="/etc/sysconfig/network-scripts/"
BOND0="ifcfg-bond0"
ETH0="ifcfg-${SLAVE1}"
ETH1="ifcfg-${SLAVE2}"
cd $DIR
if [ -f $BOND0 ]
then
    echo "bonding config file exists"
    exit 1
else
    ens1f1_state=`cat /sys/class/net/$SLAVE2/operstate`
    if [ $ens1f1_state == 'down' ]
    then
        echo "$SLAVE2 up"
        /sbin/ifconfig $SLAVE2 up
        MAXWAIT=30
        WAITED=0
        while [ "$WAITED" -lt "$MAXWAIT" ]; do
            ens1f1_state=`cat /sys/class/net/$SLAVE2/operstate`
            if [ $ens1f1_state == 'up' ]; then
                break
            else
                sleep 1
                WAITED=$((WAITED+1))
            fi
        done
    fi
    ens1f1_carrier=`cat /sys/class/net/$SLAVE2/carrier`
    if [ $ens1f1_carrier == '0' ] || [ $ens1f1_carrier == '1' ]
    then
        echo "get $SLAVE1 config"
        IPADDR=`grep -i 'ipaddr' $DIR/ifcfg-$SLAVE1 |cut -d '=' -f 2 `
        GATEWAY=`grep -i 'gateway' $DIR/ifcfg-$SLAVE1 |cut -d '=' -f 2 `
        NETMASK=`grep -i 'netmask' $DIR/ifcfg-$SLAVE1 |cut -d '=' -f 2`
        PEERDNS=`grep -i 'peerdns' $DIR/ifcfg-$SLAVE1 |cut -d '=' -f 2`
        DNS1=`grep -i 'dns1' $DIR/ifcfg-$SLAVE1 |cut -d '=' -f 2`
        DNS2=`grep -i 'dns2' $DIR/ifcfg-$SLAVE1 |cut -d '=' -f 2`
        DOMAIN=`grep -i 'domain' $DIR/ifcfg-$SLAVE1 |cut -d '=' -f 2`
        echo $IPADDR $GATEWAY $NETMASK $PEERDNS $DNS1 $DNS2 $DOMAIN
        if [ -z "$IPADDR" ] || [ -z "$GATEWAY" ] || [ -z "$NETMASK" ]; then
            echo "No IP address found on $SLAVE1"
            exit 1
        fi
        cat > $BOND0 << EOL
DEVICE="bond0"
ONBOOT="yes"
BOOTPROTO="none"
USERCTL=no
GATEWAY="$GATEWAY"
IPADDR="$IPADDR"
NETMASK="$NETMASK"
PEERDNS="$PEERDNS"
DNS1="$DNS1"
DNS2="$DNS2"
DOMAIN="$DOMAIN"
EOL
        cat > $ETH0 << EOL
DEVICE=$SLAVE1
HWADDR=$MAC1
MACADDR=$MAC1
ONBOOT=yes
BOOTPROTO=none
USERCTL=no
MASTER=bond0
SLAVE=yes
EOL
        cat > $ETH1 << EOL
DEVICE=$SLAVE2
HWADDR=$MAC2
MACADDR=$MAC2
ONBOOT=yes
BOOTPROTO=none
USERCTL=no
MASTER=bond0
SLAVE=yes
EOL
        cat > /etc/modprobe.d/bonding.conf << EOL
alias bond0 bonding
 options bond0 miimon=100 mode=4 lacp_rate=1 xmit_hash_policy=1
EOL
        echo "Please modify /etc/yunion/host.conf, replace $SLAVE1 with bond0, then restart the host"
        # /usr/bin/systemctl stop NetworkManager
        /usr/bin/systemctl disable NetworkManager
        # /sbin/service network restart
        # sleep 3
        # /sbin/service network restart
        exit 0
    else
        echo "$SLAVE2 down "
        /sbin/ifconfig $SLAVE2 down
        exit 2
    fi
fi
