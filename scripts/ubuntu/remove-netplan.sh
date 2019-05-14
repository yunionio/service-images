apt-get update
apt-get install ifupdown

#systemctl stop systemd-networkd.socket systemd-networkd \
    #networkd-dispatcher systemd-networkd-wait-online
#systemctl disable systemd-networkd.socket systemd-networkd \
    #networkd-dispatcher systemd-networkd-wait-online
systemctl mask --now systemd-networkd.socket systemd-networkd \
    networkd-dispatcher systemd-networkd-wait-online
apt-get --assume-yes purge nplan netplan.io
