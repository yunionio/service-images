```bash
# download and prepare baremetal-pxerom
$ wget https://iso.yunion.cn/yumrepo-2.10/baremetal/baremetal-pxerom-1.1.0-19111510.x86_64.rpm
$ rpm2cpio ./baremetal-pxerom-1.1.0-19111510.x86_64.rpm | cpio -idv
# download and preapre base dist web files
$ wget https://iso.yunion.cn/yumrepo-2.10/dist/dist-19121216.tar.xz
$ tar xf dist-19121216.tar.xz && mv dist-19121216 dist

$ docker build -t registry.cn-beijing.aliyuncs.com/yunionio/web-base:latest .
```
