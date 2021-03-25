
ROOT=../../..
include $(ROOT)/deps/readies/mk/main

# OSNICK=buster|stretch|bionic
OSNICK ?= bionic

REPO=redisfab
STEM=$(REPO)/redisedgevision

ifeq ($(JETSON),1)
DOCKER_SUFFIX=.jetson
endif

DOCKERFILE_STEM=$(ROOT)/vision/Dockerfile$(DOCKER_SUFFIX)

include ../versions

DOCKER_BUILD_ARGS += \
	REDISAI_VERSION=$(REDISAI_VERSION) \
	REDISTIMESERIES_VERSION=$(REDISTIMESERIES_VERSION) \
	REDISGEARS_VERSION=$(REDISGEARS_VERSION)

include $(MK)/docker.native
