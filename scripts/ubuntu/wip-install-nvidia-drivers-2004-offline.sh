#!/bin/bash

# TODO
# passing variables like http://10.168.26.219 by env
# as of https://stackoverflow.com/questions/47596369
# and https://developer.hashicorp.com/packer/docs/provisioners/shell#environment_vars
# for offline install.

set -ex

export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
export OFFLINE_REPO_PATH=/opt/ubuntu2004

init(){
    local arch=$(uname -m)
    local cuda_url=
    case $arch in
    x86_64)
        cuda_url=https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${arch}/cuda-keyring_1.1-1_all.deb
        ;;
    aarch64)
        cuda_url=https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/arm64/cuda-keyring_1.1-1_all.deb
        ;;
    *)
        echo "not supported arch $arch! "
        exit 1
        ;;
    esac
    wget $cuda_url
    sudo dpkg -i cuda-keyring_1.1-1_all.deb && rm cuda-keyring_1.1-1_all.deb

    sudo apt-get update -y
    sudo apt-get upgrade -y
    init_offline_packages
}

init_offline_packages(){
    if curl -I http://10.168.26.219:8000/ubuntu2004.tgz &>/dev/null; then
        wget http://10.168.26.219:8000/ubuntu2004.tgz -O $OFFLINE_REPO_PATH.tgz
        [[ -f $OFFLINE_REPO_PATH.tgz ]] || return 1
        tar xzf $OFFLINE_REPO_PATH.tgz -C /opt/
    fi
}

offline_deb_install(){
    [ ! -d $OFFLINE_REPO_PATH ] && return 1
    mkdir -p /var/cache/apt/archives/
    cp -f $OFFLINE_REPO_PATH/*deb /var/cache/apt/archives/
    dpkg -i /var/cache/apt/archives/*deb ||  apt --fix-broken install -y && dpkg --configure -a
}

offline_pip_install(){
    [ ! -d $OFFLINE_REPO_PATH ] && return 1
    cd $OFFLINE_REPO_PATH
    python3 -m pip install -U --no-index --find-links=file:./ torch==2.0.1 torchvision==0.1.9
}

cleanup(){
    [ ! -d $OFFLINE_REPO_PATH ] && return
    echo "cleanup"
    rm -rf $OFFLINE_REPO_PATH* &>/dev/null
    echo "before clean: "
    du -sh /var/cache/apt/archives
    sudo apt-get clean -y &>/dev/null
    du -sh /var/cache/apt/archives
    echo "fin. "
}

online_deb_install(){
    # sudo reboot # 重启
    # 重启之后更新 kernel-devel 和 kernel-headers
    # TODO remove comment
#    sudo apt-get install -y linux-headers-$(uname -r)
    sudo apt-get install -y build-essential

    # 安装NVIDIA官方驱动
    sudo apt-get install -y cuda-drivers

    # 安装CUDA
    sudo apt-get -y install cuda-toolkit-11-8

    # 安装Docker
    sudo apt-get install -y ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the repository to Apt sources:
    echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # 安装NVIDIA Docker Toolkit
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg &&
        curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list |
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list &&
        sudo apt-get update
    sudo apt-get install -y nvidia-container-toolkit
    sudo apt-get install -y git git-lfs
    sudo apt-get install -y python3-dev python3-pip
}

online_pip_install(){
    pip3 install torch==2.0.1 torchvision==0.1.9 -f https://download.pytorch.org/whl/cu102/torch_stable.html
}

trap cleanup EXIT

main(){
    init
    offline_deb_install
    online_deb_install
    offline_pip_install || online_pip_install
    python3 -c "import torch; print(torch.__version__)"
}

main
