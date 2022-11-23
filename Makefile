ROOT_DIR := $(CURDIR)
OUTPUT_DIR := $(ROOT_DIR)/_output
CACHE_DIR := $(ROOT_DIR)/_cache
CONTRIB_DIR := $(ROOT_DIR)/contrib

BUILD_IMG_CMD = ./tools/build-image.sh
BUILD_GENERIC_IMG_CMD = $(BUILD_IMG_CMD) $(CURDIR)/generic/$@.json
CREATE_IMG_CMD = ./tools/create-image.sh

NBD_DEV ?= "/dev/nbd9"
CREATE_GENERIC_IMG_CMD = $(CREATE_IMG_CMD) $(OUTPUT_DIR)/generic-$^/generic-$^ $(NBD_DEV)

img-%: %
	$(CREATE_GENERIC_IMG_CMD)

ubuntu-2004:
	$(BUILD_GENERIC_IMG_CMD)

img-ubuntu-2004: ubuntu-2004

uefi-ubuntu-2004:
	$(BUILD_GENERIC_IMG_CMD)

img-uefi-ubuntu-2004: uefi-ubuntu-2004

ubuntu-1804:
	$(BUILD_GENERIC_IMG_CMD)

img-ubuntu-1804: ubuntu-1804

uefi-ubuntu-1804:
	$(BUILD_GENERIC_IMG_CMD)

img-uefi-ubuntu-1804: uefi-ubuntu-1804

centos-7:
	$(BUILD_GENERIC_IMG_CMD)

img-centos-7: centos-7

uefi-centos-7:
	$(BUILD_GENERIC_IMG_CMD)

img-uefi-centos-7: uefi-centos-7

gpu-ubu1804:
	$(BUILD_IMG_CMD) ./gpu/ubuntu-1804.json

gpu-ubu1604:
	$(BUILD_IMG_CMD) ./gpu/ubuntu-1604.json

gpu-centos-7:
	$(BUILD_IMG_CMD) ./gpu/centos-7.json

k8s:
	$(BUILD_IMG_CMD) ./kubernetes/k8s-centos-7.json


cloudnet:
	$(BUILD_IMG_CMD) ./cloudnet/centos-7.json

# host:
# ifdef ISO_VERSION
	# @echo "Build host template $(ISO_VERSION)"
	# ./tools/host-pre-build.sh $(ISO_VERSION)
	# ./tools/build-image.sh ./host/centos7.json
# else
	# @echo "ISO_VERSION not define"
# endif

hostv34:
	$(BUILD_IMG_CMD) ./hostv3/centos7-v34.json

hostv36:
	$(BUILD_IMG_CMD) ./hostv3/centos7-v36.json

hostv39:
	$(BUILD_IMG_CMD) ./hostv3/centos7-v39.json

hostv39-uefi:
	$(BUILD_IMG_CMD) ./hostv3/uefi-centos7-v39.json

hostv3: hostv39

clean-cache:
	-rm -rf $(CACHE_DIR)

clean-contrib:
	-rm -rf $(CONTRIB_DIR)

clean-all: clean-cache clean-contrib
	-rm -rf $(OUTPUT_DIR)

.PHONY: k8s gpu-ubu1604 host clean-all clean-cache clean-contrib hostv3
