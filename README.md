# Packer templates for Yunion service

## Requirements

The following software must be installed/present on your local machine before you can use packer to build the VM images:

  - [packer](https://www.packer.io/intro/getting-started/install.html)
  - [qemu](https://www.qemu.org/download/)
  - [zerofree](https://frippery.org/uml/)
  - nbd: kernel nbd module

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

### create all kinds of template

```bash
# make centos 7 image
$ make centos7

# make ubuntu 18.04 image
$ make ubuntu-1804

# make kubernetes base image
$ make k8s

# make onecloud host image
$ make hostv3
```

### check created images

```bash
$ ls -alh ./_output/**
./_output/generic-centos-7:
total 2.2G
drwxr-xr-x 2 lzx lzx 4.0K Dec 17 21:03 .
drwxr-xr-x 4 lzx lzx 4.0K Dec 17 21:04 ..
-rw-r--r-- 1 lzx lzx 2.2G Dec 17 21:03 generic-centos-7

./_output/generic-ubuntu-1804:
total 2.2G
drwxr-xr-x 2 lzx lzx 4.0K Dec 17 22:18 .
drwxr-xr-x 5 lzx lzx 4.0K Dec 17 22:11 ..
-rw-r--r-- 1 lzx lzx 2.2G Dec 17 22:18 generic-ubuntu-1804

./_output/host:
total 3.1G
drwxr-xr-x 2 lzx lzx  4.0K Dec 10 18:59 .
drwxr-xr-x 4 lzx lzx  4.0K Dec 17 21:04 ..
-rw-r--r-- 1 lzx lzx  3.1G Dec 10 18:59 hostv3-centos7-base
```

### Zerofree and compress image

Zerofree and compress step will reduce image size

```bash
# probe nbd module
$ sudo modprobe nbd

# do zerofree and compress to shrink image size
## for generic-centos-7
$ ./tools/create-image.sh ./_output/generic-centos-7/generic-centos-7 /dev/nbd10
$ ls -alh _output/generic-centos-7/
total 2.9G
drwxr-xr-x 2 lzx lzx 4.0K Dec 17 21:09 .
drwxr-xr-x 4 lzx lzx 4.0K Dec 17 21:04 ..
-rw-r--r-- 1 lzx lzx 2.2G Dec 17 21:09 generic-centos-7
-rw-r--r-- 1 lzx lzx 702M Dec 17 21:10 generic-centos-7.qcow2

## for generic-ubuntu-1804
$ ./tools/create-image.sh ./_output/generic-ubuntu-1804/generic-ubuntu-1804 /dev/nbd9
total 2.7G
drwxr-xr-x 2 lzx lzx 4.0K Dec 17 22:18 .
drwxr-xr-x 5 lzx lzx 4.0K Dec 17 22:11 ..
-rw-r--r-- 1 lzx lzx 2.2G Dec 17 22:18 generic-ubuntu-1804
-rw-r--r-- 1 lzx lzx 524M Dec 17 22:19 generic-ubuntu-1804.qcow2

## for onecloud host
$ ./tools/create-image.sh ./_output/host/hostv3-centos7-base /dev/nbd11
$ ls -alh ./_output/host
total 3.8G
drwxr-xr-x 2 lzx lzx   62 May 15 22:55 .
drwxr-xr-x 3 lzx lzx   18 May 15 22:36 ..
-rw-r--r-- 1 lzx lzx 3.1G May 15 22:55 hostv3-centos7-base
-rw-r--r-- 1 lzx lzx 934M May 15 22:59 hostv3-centos7-base.qcow2
```

## Upload image to OneCloud

```bash
# use onecloud climc upload image
$ climc image-upload --format qcow2 --os-type Linux --os-arch x86_64 \
    --standard generic-centos-7 ./_output/generic-centos-7/generic-centos-7.qcow2
```

## Connect to building VM

The VM will be run headless mode without a GUI, use VNC client to connect build VM graphic console.
