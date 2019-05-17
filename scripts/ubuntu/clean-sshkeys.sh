#!/bin/bash

rm -vf /etc/ssh/ssh_host_*

ssh_initkey="/etc/init.d/ssh-initkey"
cat <<EOF >$ssh_initkey
#! /bin/sh
### BEGIN INIT INFO
# Provides:          ssh-initkey
# Required-Start:
# Required-Stop:
# X-Start-Before:    ssh
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: init ssh host keys
### END INIT INFO

PATH=/sbin:/usr/sbin:/bin:/usr/bin
. /lib/init/vars.sh
. /lib/lsb/init-functions
do_start() {
    ls /etc/ssh/ssh_host_* > /dev/null 2>&1
    if [ \$? -ne 0 ]; then
        dpkg-reconfigure openssh-server
    fi
}
case "\$1" in
    start)
    do_start
        ;;
    restart|reload|force-reload)
        echo "Error: argument '\$1' not supported" >&2
        exit 3
        ;;
    stop)
        ;;
    *)
        echo "Usage: \$0 start|stop" >&2
        exit 3
        ;;
esac
EOF

chmod a+x $ssh_initkey
/usr/sbin/update-rc.d ssh-initkey defaults
/usr/sbin/update-rc.d ssh-initkey enable
