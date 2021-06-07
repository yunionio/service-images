REGISTRY ?= "registry.cn-beijing.aliyuncs.com/yunionio"
VERSION ?= "3.6.1"

build:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(REGISTRY)/web-base:$(VERSION) -f Dockerfile . --push
