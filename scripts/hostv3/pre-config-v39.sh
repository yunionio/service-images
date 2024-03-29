#!/bin/bash

yum-config-manager --add-repo https://iso.yunion.cn/centos/7/3.9/x86_64/yunion.repo
systemctl disable firewalld
systemctl enable ntpd
echo 'yunion ALL = NOPASSWD: ALL' > /etc/sudoers.d/yunion

mkdir -p /etc/modules-load.d
mkdir -p /etc/sysconfig/modules
mkdir -p /opt/cloud
mkdir -p /opt/yunion
mkdir -p /etc/docker

