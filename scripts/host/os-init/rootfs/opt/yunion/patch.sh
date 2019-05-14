#!/usr/bin/env bash
 
CURDIR=/opt/yunion/upgrade
for i in cloud dist rpms/updates yunionsetup libs rpms/packages
do
    if [ ! -d $CURDIR/$i ]; then
        sudo mkdir -p $CURDIR/$i
        sudo chown -R yunion:yunion $CURDIR/$i
    fi
done
 
ver=`cat /opt/yunion/upgrade/version`
for f in all.sh git.sh install_init.sh install_params.sh iso.sh log.sh misc.sh params.sh prereq.sh tui.sh
do
    url=https://iso.yunion.cn/$ver/libs/$f  
    curl -o $CURDIR/libs/$f $url   
done
curl -o $CURDIR/downloader.sh  https://iso.yunion.cn/$ver/downloader.sh
chmod +x /opt/yunion/upgrade/libs/*.sh 
 
chmod +x /opt/yunion/upgrade/*.sh
