REGISTRY ?= "registry.cn-beijing.aliyuncs.com/yunionio"
VERSION ?= "v3.10.3-20240808.2"

build:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(REGISTRY)/web-base:$(VERSION) -f Dockerfile . --push
