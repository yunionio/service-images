FROM nginx

RUN mkdir -p /opt/cloud/yunion/baremetal/baremetal-prepare
COPY ./opt/cloud/yunion/baremetal/baremetal-prepare/baremetal_prepare.tar.gz /opt/cloud/yunion/baremetal/baremetal-prepare
COPY ./dist/bi /usr/share/nginx/html/bi
COPY ./dist/itsm /usr/share/nginx/html/itsm
COPY ./dist/servicetree /usr/share/nginx/html/servicetree
COPY ./dist/web-console /usr/share/nginx/html/web-console
COPY ./yunion.conf /etc/nginx/conf.d/default.conf
