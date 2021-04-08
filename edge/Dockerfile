# BUILD redisfab/redisedge:${VERSION}-cpu-${ARCH}-${OSNICK}

ARG VERSION=0.4.0

# OSNICK=stretch|bionic|buster
ARG OSNICK=bionic

# ARCH=x64|arm64v8|arm32v7
ARG ARCH=x64

ARG REDISAI_VERSION=1.0.2
ARG REDISTIMESERIES_VERSION=1.4.6
ARG REDISGEARS_VERSION=1.0.2
ARG REDIS_VER=6.2.1
ARG DEVICE=cpu

ARG DOCKER_ORG=redisfab

# done to specifically allow for ease of optional override with --build-arg
ARG REDISAI_DOCKERDEP=${REDISAI_VERSION}-${DEVICE}-${ARCH}-${OSNICK}
ARG REDISTIMESERIES_DOCKERDEP=${REDISTIMESERIES_VERSION}-${ARCH}-${OSNICK}
ARG REDISGEARS_DOCKERDEP=${REDISGEARS_VERSION}-${ARCH}-${OSNICK}
ARG REDIS_DOCKERDEP=${REDIS_VER}-${ARCH}-${OSNICK}

#----------------------------------------------------------------------------------------------
FROM ${DOCKER_ORG}/redisai:${REDISAI_DOCKERDEP} as ai
FROM ${DOCKER_ORG}/redistimeseries:${REDISTIMESERIES_DOCKERDEP} as timeseries
FROM ${DOCKER_ORG}/redisgears:${REDISGEARS_DOCKERDEP} as gears

#----------------------------------------------------------------------------------------------
FROM redisfab/redis:${REDIS_DOCKERDEP}

ARG OSNICK
ARG ARCH
ARG VERSION
ARG REDISAI_VERSION
ARG REDISTIMESERIES_VERSION
ARG REDISGEARS_VERSION
ARG REDIS_VER
ARG REDISTIMESERIES_DOCKERDEP
ARG REDISGEARS_DOCKERDEP
ARG REDIS_DOCKERDEP
ARG REDISAI_DOCKERDEP

RUN echo "Building redisedge-${OSNICK}:${VERSION}-${DEVICE}-${ARCH} with:" ;\
    echo "  RedisAI=${REDISAI_DOCKERDEP}-${DEVICE}" ;\
    echo "  RedisTimeSeries=${REDISTIMESERIES_DOCKERDEP}" ;\
    echo "  RedisGears=${REDISGEARS_DOCKERDEP}" ;\
    echo "  Redis=${REDIS_DOCKERDEP}"

RUN set -e; if [ ! -z $(command -v apt-get) ]; then apt-get -qq update; apt-get -q install -y libgomp1 git; fi
RUN set -e; if [ ! -z $(command -v yum) ]; then yum install -y libgomp git; fi

ENV LIBDIR /usr/lib/redis/modules
ENV LD_LIBRARY_PATH $LIBDIR
WORKDIR /data
RUN mkdir -p ${LIBDIR}

COPY --from=timeseries --chown=redis:redis ${LIBDIR}/*.so ${LIBDIR}/
COPY --from=ai --chown=redis:redis ${LIBDIR}/ ${LIBDIR}/
COPY --from=gears --chown=redis:redis /var/opt/redislabs/lib/modules/redisgears.so ${LIBDIR}/
COPY --from=gears --chown=redis:redis /var/opt/redislabs/modules/ /var/opt/redislabs/modules/

WORKDIR /var/opt/redislabs/modules/rg
RUN ln -s python3 python3_`cat /var/opt/redislabs/artifacts/VERSION`

ADD redisedge.conf /etc
CMD ["/etc/redisedge.conf"]
