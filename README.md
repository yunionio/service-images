# Packer templates for Yunion service

## Requirements

The following software must be installed/present on your local machine before you can use packer to build the VM images:

  - [packer](https://www.packer.io/intro/getting-started/install.html)
  - [qemu](https://www.qemu.org/download/)
  - [zerofree](https://frippery.org/uml/)

### Install dependencies

#### packer

```bash
$ wget https://releases.hashicorp.com/packer/1.4.1/packer_1.4.1_linux_amd64.zip
$ unzip ./packer_1.4.1_linux_amd64.zip
$ mv ./packer /usr/bin
```

#### qemu & zerofree

```bash
# centos
$ yum install -y qemu zerofree seabios seabios-bin
# archlinux
$ pacman -S qemu zerofree seabios
```

## Usage

### create k8s template

```bash
# make kubernetes base image
$ make k8s
```

### create host template

```bash
# MUST define ISO_VERSION
$ make ISO_VERSION=2.9.20190516.0 host

# check template image
$ ls -alh ./_output/host
total 2.9G
drwxr-xr-x 2 lzx lzx   31 May 15 22:53 .
drwxr-xr-x 3 lzx lzx   18 May 15 22:36 ..
-rw-r--r-- 1 lzx lzx 2.9G May 15 22:53 host-centos7-base
```

### Zerofree and compress image

```bash
# do zerofree and compress to shrink image size
$ ./tools/create-image.sh ./_output/host/host-centos7-base
$ ls -alh ./_output/host
total 3.8G
drwxr-xr-x 2 lzx lzx   62 May 15 22:55 .
drwxr-xr-x 3 lzx lzx   18 May 15 22:36 ..
-rw-r--r-- 1 lzx lzx 2.9G May 15 22:55 host-centos7-base
-rw-r--r-- 1 lzx lzx 934M May 15 22:59 host-centos7-base.qcow2
```

## Connect to building VM

The VM will be run headless mode without a GUI, use VNC client to connect build VM graphic console.
