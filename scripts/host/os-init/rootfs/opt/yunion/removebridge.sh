#!/bin/bash

interface_ip() {
    ip address show dev $1 | grep "inet " | awk '{print $2}' | head -n 1
}

interface_gw() {
    ip route | grep "default via" | grep "dev $1" | awk '{print $3}' | head -n 1
}

remove() {
    local BR=$1
    echo "Remove brige $BR..."
    PORT_CNT=$(ovs-vsctl list-ifaces $BR | wc -l)
    if [ "$PORT_CNT" -eq "0" ]; then
        echo "No interface with bridge $BR, delete anyway ..."
    elif [ "$PORT_CNT" -lt "1" ]; then
        echo "More than 1 interface join bridge $BR, please remove bridge manually ..."
        return
    else
        ETH=$(ovs-vsctl list-ifaces $BR)
        echo "Only 1 interface joint bridge $BR, I will remove bridge and bring up $ETH ..."
        IP=$(interface_ip $BR)
        if [ -n "$IP" ]; then
            ip address change $IP dev $ETH
        fi
        GW=$(interface_gw $BR)
        if [ -n "$GW" ]; then
            route add default gw $GW dev $ETH
        fi
    fi
    ovs-vsctl del-br $BR
}

for br in $(ovs-vsctl list-br)
do
    remove $br
done
