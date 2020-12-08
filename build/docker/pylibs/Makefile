
ROOT=../../..
include $(ROOT)/deps/readies/mk/main

# OSNICK=buster|stretch|bionic
OSNICK ?= bionic

REPO=redisfab
STEM=$(REPO)/redisedge-pylibs

DOCKERFILE_STEM=$(ROOT)/visionlibs/Dockerfile

include ../versions

DOCKER_BUILD_ARGS += \
	VERSION=$(VERSION)

include $(MK)/docker
