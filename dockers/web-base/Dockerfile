FROM centos:7 AS baremetal
RUN yum install -y wget
RUN wget -O /tmp/baremetal-pxerom.rpm https://iso.yunion.cn/misc/baremetal-pxerom-1.1.0-20030322.x86_64.rpm
RUN yum install -y /tmp/baremetal-pxerom.rpm

FROM registry.cn-beijing.aliyuncs.com/yunionio/web-console-fe:v3.1 as web-console

FROM nginx
RUN mkdir -p /opt/cloud/yunion/baremetal/baremetal-prepare
COPY --from=baremetal /opt/cloud/yunion/baremetal/baremetal-prepare/baremetal_prepare.tar.gz /opt/cloud/yunion/baremetal/baremetal-prepare
COPY --from=web-console /usr/share/nginx/html/web-console /usr/share/nginx/html/web-console
COPY ./dist/bi /usr/share/nginx/html/bi
COPY ./dist/itsm /usr/share/nginx/html/itsm
COPY ./dist/servicetree /usr/share/nginx/html/servicetree
COPY ./yunion.conf /etc/nginx/conf.d/default.conf
