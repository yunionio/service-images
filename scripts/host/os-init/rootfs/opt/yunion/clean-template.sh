#!/bin/bash

for srv in httpd nginx mariadb influxdb
do
    sudo systemctl stop $srv
    sudo systemctl disable $srv
done

sudo systemctl disable openvswitch
sudo chkconfig openvswitch off

sudo systemctl disable docker

sudo systemctl start openvswitch
for br in $(sudo ovs-vsctl list-br)
do
    sudo ovs-vsctl del-br $br
done
sudo systemctl stop openvswitch

sudo rm -fr /etc/systemd/system/yunion-*.service
sudo systemctl daemon-reload

sudo rm -fr /opt/cloud/workspace
sudo rm -fr /var/lib/mysql/*
sudo rm -fr /var/lib/influxdb/*
sudo rm -fr /run/httpd
sudo rm -f /opt/yunionsetup/vars
sudo rm -f /etc/sysconfig/network-scripts/ifcfg-eth*
sudo rm -f /etc/yunion/*.conf

sudo yum clean all

sudo rm -rf /var/cache/yum

for f in boot.log btmp cron maillog messages secure spooler yum.log
do
    sudo rm -fr /var/log/$f*
done

for d in apache2 httpd influxdb mariadb nginx openvswitch telegraf
do
    if [ -d /var/log/$d ]; then
        sudo rm -fr /var/log/$d/*
    fi
done

rm -fr $HOME/.ssh
rm -fr $HOME/.bash_history
rm -fr $HOME/.vim*

sudo rm -f /etc/hosts
sudo touch /etc/hosts
