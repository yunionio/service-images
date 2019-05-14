#!/bin/bash

/usr/bin/systemctl stop NetworkManager
/sbin/service network restart
sleep 3
/sbin/service network restart
