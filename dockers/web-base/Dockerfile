FROM registry.cn-beijing.aliyuncs.com/yunionio/centos-build:1.1-4 AS baremetal
RUN wget -O /tmp/baremetal-pxerom.rpm https://iso.yunion.cn/vm-images/baremetal-pxerom-1.1.0-21060506.x86_64.rpm
RUN rpm2cpio /tmp/baremetal-pxerom.rpm | cpio -idmv
RUN cp -a ./opt/* /opt

FROM --platform=linux/amd64 registry.cn-beijing.aliyuncs.com/yunionio/web-console-fe:v3.10.3-20230619.1 as web-console

FROM nginx:1.21.0
RUN mkdir -p /opt/cloud/yunion/baremetal/baremetal-prepare
COPY --from=baremetal /opt/cloud/yunion/baremetal/baremetal-prepare/baremetal_prepare.tar.gz /opt/cloud/yunion/baremetal/baremetal-prepare
COPY --from=web-console /usr/share/nginx/html/web-console /usr/share/nginx/html/web-console
