# BUILD redisfab/redisedge:${VERSION}-cpu-${ARCH}-${OSNICK}

ARG VERSION=0.4.0

# OSNICK=stretch|bionic|buster
ARG OSNICK=bionic

# ARCH=x64|arm64v8|arm32v7
ARG ARCH=x64

ARG REDISAI_VERSION=1.0.2
ARG REDISTIMESERIES_VERSION=1.4.6
ARG REDISGEARS_VERSION=1.0.2
ARG REDIS_VERSION=6.0.9
ARG DEVICE=cpu

# done to specifically allow for ease of optional override with --build-arg
ARG REDISAI_DOCKERDEP=${REDISAI_VERSION}-${DEVICE}-${ARCH}-${OSNICK}
ARG REDISTIMESERIES_DOCKERDEP=${REDISTIMESERIES_VERSION}-${ARCH}-${OSNICK}
ARG REDISGEARS_DOCKERDEP=${REDISGEARS_VERSION}-${ARCH}-${OSNICK}
ARG REDIS_DOCKERDEP=${REDIS_VERSION}-${ARCH}-${OSNICK}

#----------------------------------------------------------------------------------------------
FROM redisfab/redisai:${REDISAI_VERSION}-cpu-${ARCH}-${OSNICK} as ai
FROM redisfab/redistimeseries:${REDISTIMESERIES_VERSION}-${ARCH}-${OSNICK} as timeseries
FROM redisfab/redisgears:${REDISGEARS_VERSION}-${ARCH}-${OSNICK} as gears

#----------------------------------------------------------------------------------------------
FROM redisfab/redis:${REDIS_DOCKERDEP}

ARG OSNICK
ARG ARCH
ARG VERSION
ARG REDISAI_VERSION
ARG REDISTIMESERIES_VERSION
ARG REDISGEARS_VERSION
ARG REDIS_VERSION

RUN echo "Building redisedge-${OSNICK}:${VERSION}-${DEVICE}-${ARCH} with:" ;\
    echo "  RedisAI=${REDISAI_DOCKERDEP}-${DEVICE}" ;\
    echo "  RedisTimeSeries=${REDISTIMESERIES_DOCKERDEP}" ;\
    echo "  RedisGears=${REDISGEARS_DOCKERDEP}" ;\
    echo "  Redis=${REDIS_DOCKERDEP}"

RUN set -e; if [ ! -z $(command -v apt-get) ]; then apt-get -qq update; apt-get -q install -y libgomp1; fi
RUN set -e; if [ ! -z $(command -v yum) ]; then yum install -y libgomp; fi

ENV LIBDIR /usr/lib/redis/modules
ENV LD_LIBRARY_PATH $LIBDIR
WORKDIR /data
RUN mkdir -p ${LIBDIR}

COPY --from=timeseries ${LIBDIR}/*.so ${LIBDIR}/
COPY --from=ai         ${LIBDIR}/ ${LIBDIR}/
COPY --from=gears      /var/opt/redislabs/lib/modules/redisgears.so ${LIBDIR}/
COPY --from=gears      /var/opt/redislabs/modules/ /var/opt/redislabs/modules/

ADD redisedge.conf /etc
CMD ["/etc/redisedge.conf"]
