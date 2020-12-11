
JETSON_MODEL ?= nano
BASE_OS ?= ubuntu:bionic
BASE_OSNICK ?= bionic
# BASE_OSNICK ?= l4t

ROOTDIRS=etc usr opt
SPEC=redisfab/jetson-jetpack:4.4.1-$(JETSON_MODEL)-arm64v8-$(BASE_OSNICK)

CID=/tmp/jetson.cid

build:
	rm -f $(CID)
	docker run --cidfile $(CID) $(foreach d,$(ROOTDIRS),-v /$(d):/x$(d)) -v $(PWD):/build $(BASE_OS) bash /build/build.sh
	docker commit `cat $(CID)` $(SPEC)
	docker rm `cat $(CID)`
	rm $(CID)
