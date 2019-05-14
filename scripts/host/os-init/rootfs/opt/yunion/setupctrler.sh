#!/bin/bash


sudo systemctl enable mariadb
sudo systemctl start mariadb

sudo rm -fr /run/httpd/
sudo mkdir /run/httpd/

if [ -e /opt/yunionsetup/vars ]; then
    . /opt/yunionsetup/vars
fi

MYROOTPASS=openstack
if [ -n "$MYSQL_ROOT_PASS" ]; then
    MYROOTPASS=$MYSQL_ROOT_PASS
fi
mysqladmin -u root password "$MYROOTPASS"

mysql --user=root --password=$MYROOTPASS mysql -e "grant all on *.* to 'root'@'%' identified by '$MYROOTPASS' with grant option"
mysql --user=root --password=$MYROOTPASS mysql -e "flush privileges"

cd /opt/yunionsetup

./setup.sh

./scripts/all_setup.sh
