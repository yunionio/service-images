#!/bin/bash

set -e

yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum install --assumeyes docker-ce-18.09.1 docker-ce-cli-18.09.1 containerd.io

