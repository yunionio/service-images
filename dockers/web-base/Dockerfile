FROM --platform=linux/amd64 centos:7 AS baremetal
RUN yum install -y wget
RUN wget -O /tmp/baremetal-pxerom.rpm https://iso.yunion.cn/3.2/rpms/packages/host/baremetal-pxerom-1.1.0-20072810.x86_64.rpm
RUN yum install -y /tmp/baremetal-pxerom.rpm

FROM --platform=linux/amd64 registry.cn-beijing.aliyuncs.com/yunionio/web-console-fe:v3.1 as web-console

FROM nginx
RUN mkdir -p /opt/cloud/yunion/baremetal/baremetal-prepare
COPY --from=baremetal /opt/cloud/yunion/baremetal/baremetal-prepare/baremetal_prepare.tar.gz /opt/cloud/yunion/baremetal/baremetal-prepare
COPY --from=web-console /usr/share/nginx/html/web-console /usr/share/nginx/html/web-console
