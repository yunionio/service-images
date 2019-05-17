#!/usr/bin/env bash

# Remove Linux headers
# yum -y remove gcc kernel-devel kernel-headers perl cpp
yum -y clean all

# Cleanup log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;

# remove under tmp directory
rm -rf /tmp/* /var/tmp/*

# remove ssh keypair
rm -vf /etc/ssh/ssh_host_*

# zero log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;
