
# SHELL:=$(shell sh -c "command -v bash")

JETSON_MODEL ?= nano

TEGRA_RELEASE:=$(shell cat /etc/nv_tegra_release | sed -e 's/\# \([^ ]*\).*/\L\1/g')
TEGRA_REV:=$(shell cat /etc/nv_tegra_release | sed -e 's/.*REVISION: \([^,]*\).*/\1/g')
JETPACK_VER.4.4=4.4.1
JETPACK_VER=$(JETPACK_VER.$(TEGRA_REV))

BASE_OS ?= ubuntu:bionic
BASE_OSNICK ?= bionic
BASE_OS=nvcr.io/nvidia/l4t-base:$(TEGRA_RELEASE).$(TEGRA_REV)
# BASE_OSNICK ?= l4t

ROOTDIRS=etc usr opt
IMAGE=redisfab/jetson-jetpack:$(JETPACK_VER)-$(JETSON_MODEL)-arm64v8-$(BASE_OSNICK)

CID=/tmp/jetson.cid

build:
	rm -f $(CID)
	docker run --cidfile $(CID) $(foreach d,$(ROOTDIRS),-v /$(d):/x$(d)) -v $(PWD):/build $(BASE_OS) bash /build/build.sh
	docker commit `cat $(CID)` $(IMAGE)
	docker rm `cat $(CID)`
	rm $(CID)

publish:
	docker push $(IMAGE)

info:
	@echo "TEGRA_RELEASE=$(TEGRA_RELEASE)"
	@echo "TEGRA_REV=$(TEGRA_REV)"
	@echo "JETPACK_VER=$(JETPACK_VER)"
	@echo "JETSON_MODEL=$(JETSON_MODEL)"
	@echo "BASE_OS=$(BASE_OS)"
	@echo "IMAGE=$(IMAGE)"
