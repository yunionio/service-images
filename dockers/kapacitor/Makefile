REGISTRY ?= "registry.cn-beijing.aliyuncs.com/yunionio"
VERSION ?= "1.5"

image:
	sudo docker build -f Dockerfile -t $(REGISTRY)/kapacitor:$(VERSION) .

image-push: image
	sudo docker push $(REGISTRY)/kapacitor:$(VERSION)
