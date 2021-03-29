
ROOT=..
MK.pyver:=3
include $(ROOT)/deps/readies/mk/main

# OSNICK=buster|stretch|bionic
OSNICK ?= bionic

REPO=redisedge-pylibs

ifeq ($(JETSON),1)
DOCKER_SUFFIX=.jetson
endif

DOCKERFILE_STEM=$(ROOT)/pylibs/Dockerfile$(DOCKER_SUFFIX)

include ../versions

DOCKER_BUILD_ARGS += \
	VERSION=$(VERSION)

include $(MK)/docker.native
