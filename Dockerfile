# BUILD redisfab/redisedge-${OSNICK}:${VERSION}-${ARCH}

ARG VERSION=0.2.0

# OSNICK=stretch|bionic|buster
ARG OSNICK=buster

# ARCH=x64|arm64v8|arm32v7
ARG ARCH=x64

ARG REDISAI_VERSION=0.3.2
ARG REDISTIMESERIES_VERSION=1.0.3
ARG REDISGEARS_VERSION=0.4.0

#----------------------------------------------------------------------------------------------
FROM redisfab/redisai-cpu-${OSNICK}:${REDISAI_VERSION}-${ARCH} as ai
FROM redisfab/redistimeseries-${OSNICK}:${REDISTIMESERIES_VERSION}-${ARCH} as timeseries
FROM redisfab/redisgears-${OSNICK}:${REDISGEARS_VERSION}-${ARCH} as gears

#----------------------------------------------------------------------------------------------
FROM redisfab/redis-${ARCH}-${OSNICK}:5.0.5

ARG OSNICK
ARG ARCH
ARG VERSION
ARG REDISAI_VERSION
ARG REDISTIMESERIES_VERSION
ARG REDISGEARS_VERSION

RUN echo "Building redisedge-${OSNICK}:${VERSION}-${ARCH} with:" ;\
	echo "  RedisAI=${REDISAI_VERSION}" ;\
	echo "  RedisTimeSeries=${REDISTIMESERIES_VERSION}" ;\
	echo "  RedisGears=${REDISGEARS_VERSION}"

RUN set -e ;\
	apt-get -qq update; apt-get -q install -y libgomp1

ENV LIBDIR /usr/lib/redis/modules
ENV LD_LIBRARY_PATH $LIBDIR
WORKDIR /data
RUN mkdir -p ${LIBDIR}

COPY --from=timeseries ${LIBDIR}/*.so ${LIBDIR}/
COPY --from=ai         ${LIBDIR}/ ${LIBDIR}/
COPY --from=gears      /opt/redislabs/lib/modules/redisgears.so ${LIBDIR}/
COPY --from=gears      /opt/redislabs/ /opt/redislabs/

ADD redisedge.conf /etc
CMD ["/etc/redisedge.conf"]
