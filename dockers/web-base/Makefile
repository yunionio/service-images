REGISTRY ?= "registry.cn-beijing.aliyuncs.com/yunionio"
VERSION ?= "latest"

build:
	docker buildx build --platform linux/amd64,linux/arm64 -t $(REGISTRY)/web-base:$(VERSION) -f Dockerfile . --push
	docker pull $(REGISTRY)/web-base:$(VERSION)
