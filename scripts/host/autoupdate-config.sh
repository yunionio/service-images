#!/bin/bash

set -x
set -e

update_repo_dir=/opt/repo

mkdir -p $update_repo_dir && cd $update_repo_dir

curl -OL https://iso.yunion.cn/yumrepo-2.8/yunion-sdnagent-2.8.20190505.0-19050510.x86_64.rpm
curl -OL https://iso.yunion.cn/yumrepo-2.8/yunion-kube-agent-2.9.20190422.0-19042303.x86_64.rpm
curl -OL https://iso.yunion.cn/yumrepo-2.8/yunion-autoupdate-2.8.20190415.1-19041516.x86_64.rpm
curl -OL https://iso.yunion.cn/yumrepo-2.8/yunion-host-2.8.20190513.2-19051321.x86_64.rpm
