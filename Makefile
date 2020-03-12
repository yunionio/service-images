ROOT_DIR := $(CURDIR)
OUTPUT_DIR := $(ROOT_DIR)/_output
CACHE_DIR := $(ROOT_DIR)/_cache
CONTRIB_DIR := $(ROOT_DIR)/contrib

k8s:
	./tools/build-image.sh ./kubernetes/k8s-centos7.json

gpu-ubu1804:
	./tools/build-image.sh ./gpu/ubuntu-1804.json

gpu-ubu1604:
	./tools/build-image.sh ./gpu/ubuntu-1604.json

gpu-centos7:
	./tools/build-image.sh ./gpu/centos-7.json

cloudnet:
	./tools/build-image.sh ./cloudnet/centos-7.json

host:
ifdef ISO_VERSION
	@echo "Build host template $(ISO_VERSION)"
	./tools/host-pre-build.sh $(ISO_VERSION)
	./tools/build-image.sh ./host/centos7.json
else
	@echo "ISO_VERSION not define"
endif

hostv3:
	./tools/build-image.sh ./hostv3/centos7.json

clean-cache:
	-rm -rf $(CACHE_DIR)

clean-contrib:
	-rm -rf $(CONTRIB_DIR)

clean-all: clean-cache clean-contrib
	-rm -rf $(OUTPUT_DIR)

.PHONY: k8s gpu-ubu1604 host clean-all clean-cache clean-contrib hostv3
