#!/usr/bin/env bash

# Remove Linux headers
# yum -y remove gcc kernel-devel kernel-headers perl cpp
yum -y clean all

# Cleanup log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;

# remove under tmp directory
rm -rf /tmp/* /var/tmp/*

# remove ssh keypair
rm -f /etc/ssh/*_key /etc/ssh/*_key.pub

# zero log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;
