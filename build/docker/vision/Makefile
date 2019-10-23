
ROOT=../../..
include $(ROOT)/deps/readies/mk/main

# OSNICK=buster|stretch|bionic
OSNICK ?= buster

REPO=redisfab
STEM=$(REPO)/redisedgevision

DOCKERFILE_STEM=$(ROOT)/vision/Dockerfile

include ../versions

DOCKER_BUILD_ARGS += \
	VERSION=$(VERSION) \
	REDISAI_VERSION=$(REDISAI_VERSION) \
	REDISTIMESERIES_VERSION=$(REDISTIMESERIES_VERSION) \
	REDISGEARS_VERSION=$(REDISGEARS_VERSION)

include $(MK)/docker
