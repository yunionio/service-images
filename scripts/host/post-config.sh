#!/bin/bash

set -e

systemctl enable yunion

touch /etc/sysconfig/yunionauth && chmod 644 /etc/sysconfig/yunionauth

chown -R yunion:yunion /opt/yunionsetup
chown -R yunion:yunion /opt/cloud
chown -R yunion:yunion /opt/yunion

/opt/yunion/patch.sh

/opt/yunion/clean-template.sh
