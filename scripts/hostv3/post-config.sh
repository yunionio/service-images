#!/bin/bash

set -e

systemctl enable docker
systemctl enable kubelet
systemctl enable yunion
systemctl enable yunion-executor

touch /etc/sysconfig/yunionauth && chmod 644 /etc/sysconfig/yunionauth

chown -R yunion:yunion /opt/cloud
chown -R yunion:yunion /opt/yunion
