#!/usr/bin/env bash

set -e

yum install -y python-pip

# config pip
mkdir ~/.pip/
cat <<EOF > ~/.pip/pip.conf
[global]
index-url = http://pypi.douban.com/simple
[install]
trusted-host = pypi.douban.com
EOF

# download cloud-init 18.5
cd /tmp
curl -LO https://launchpad.net/cloud-init/trunk/18.5/+download/cloud-init-18.5.tar.gz
tar -zxvf cloud-init-18.5.tar.gz && cd cloud-init-18.5
pip install -r ./requirements.txt
python setup.py build
python setup.py install --init-system systemd

cat <<EOF >/etc/cloud/cloud.cfg
users:
 - default

disable_root: 0
ssh_pwauth:   1
chpasswd: {expire: False}

mount_default_fields: [~, ~, 'auto', 'defaults,nofail,x-systemd.requires=cloud-init.service', '0', '2']
resize_rootfs_tmp: /dev
ssh_deletekeys:   0
ssh_genkeytypes:  ~
syslog_fix_perms: ~

cloud_init_modules:
 - disk_setup
 - migrator
 - bootcmd
 - write-files
 - growpart
 - resizefs
 - set_hostname
 - update_hostname
 - update_etc_hosts
 - rsyslog
 - users-groups
 - ssh

cloud_config_modules:
 - mounts
 - locale
 - set-passwords
 - rh_subscription
 - yum-add-repo
 - package-update-upgrade-install
 - timezone
 - puppet
 - chef
 - salt-minion
 - mcollective
 - disable-ec2-metadata
 - runcmd

cloud_final_modules:
 - rightscale_userdata
 - scripts-per-once
 - scripts-per-boot
 - scripts-per-instance
 - scripts-user
 - ssh-authkey-fingerprints
 - keys-to-console
 - phone-home
 - final-message
 - power-state-change

system_info:
  default_user:
    name: centos
    lock_passwd: true
    gecos: Cloud User
    groups: [wheel, adm, systemd-journal]
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    shell: /bin/bash
  distro: rhel
  paths:
    cloud_dir: /var/lib/cloud
    templates_dir: /etc/cloud/templates
  ssh_svcname: sshd

# vim:syntax=yaml
EOF

cat <<EOF >/etc/cloud/cloud.cfg.d/99-ec2-datasource.cfg
#cloud-config
datasource:
  Ec2:
    strict_id: false
EOF

systemctl enable cloud-init
