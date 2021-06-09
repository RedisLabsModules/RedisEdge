DOCKER_ORG=redislabs
PRODUCT=redisedge
VARIANT=cpu
OSNICK=bionic
DEBIAN_OSNICK=buster

VERISON ?= edge
VARIANT=cpu
ifeq ($(GPU),1)
VARIANT=gpu
endif

export REDIS_DOCKER_ORG=redislabs
export REDISAI_DOCKERTAG=${VERSION}-${VARIANT}-${OSNICK}
export REDISGEARS_DOCKERTAG=${VERSION}
export REDISTIMESERIES_DOCKERTAG=${VERSION}
export REDIS_DOCKERTAG=latest

ROOT=../
READIES=${ROOT}/deps/readies
include ${READIES}/mk/docker.rules
