FROM registry.cn-beijing.aliyuncs.com/yunionio/onecloud-base:v0.2

MAINTAINER "Zexi Li <zexi.li@qq.com>"

RUN apk add --no-cache bash
RUN apk add --no-cache s3fs-fuse --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing

COPY run.sh /run.sh
