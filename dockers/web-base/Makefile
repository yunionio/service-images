REGISTRY ?= "registry.cn-beijing.aliyuncs.com/yunionio"
VERSION ?= "latest"

build:
	sudo docker build -f Dockerfile -t $(REGISTRY)/web-base:$(VERSION) .
	sudo docker push $(REGISTRY)/web-base:$(VERSION)
