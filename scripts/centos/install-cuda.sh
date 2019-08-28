#!/bin/bash

# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=CentOS&target_version=7&target_type=rpmlocal

wget http://developer.download.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda-repo-rhel7-10-1-local-10.1.243-418.87.00-1.0-1.x86_64.rpm

sudo rpm -i cuda-repo-rhel7-10-1-local-10.1.243-418.87.00-1.0-1.x86_64.rpm

sudo yum clean all

sudo yum -y install nvidia-driver-latest-dkms cuda

rm ./cuda*
