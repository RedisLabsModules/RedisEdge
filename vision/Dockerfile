# BUILD redisfab/redisedgevision-${OSNICK}:${VERSION}-${ARCH}

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
# FROM redisfab/redisedgevisionlibs-${OSNICK}:${REDISEDGEVISIONLIBS_VERSION}-${ARCH} as visionlibs

#----------------------------------------------------------------------------------------------
FROM redisfab/redis-${ARCH}-${OSNICK}:5.0.5

ARG OSNICK
ARG ARCH
ARG VERSION
ARG REDISAI_VERSION
ARG REDISTIMESERIES_VERSION
ARG REDISGEARS_VERSION

RUN echo "Building redisedgevision-${OSNICK}:${VERSION}-${ARCH} with:" ;\
	echo "  RedisAI=${REDISAI_VERSION}" ;\
	echo "  RedisTimeSeries=${REDISTIMESERIES_VERSION}" ;\
	echo "  RedisGears=${REDISGEARS_VERSION}"

WORKDIR /tmp

COPY deps/ deps/
ADD vision/system-setup.py .

RUN ./deps/readies/bin/getpy3
RUN ./system-setup.py 

WORKDIR /data

ENV REDISMODULES_LIBS /usr/lib/redis/modules
ENV LD_LIBRARY_PATH ${REDISMODULES_LIBS}:${LD_LIBRARY_PATH}
RUN mkdir -p ${REDISMODULES_LIBS}

COPY --from=timeseries ${REDISMODULES_LIBS}/*.so ${REDISMODULES_LIBS}/
COPY --from=ai         ${REDISMODULES_LIBS}/ ${REDISMODULES_LIBS}/
COPY --from=gears      /opt/redislabs/lib/modules/redisgears.so ${REDISMODULES_LIBS}/
COPY --from=gears      /opt/redislabs/ /opt/redislabs/
# COPY --from=visionlibs /usr/local/ /usr/local/

RUN echo /usr/lib/python3/dist-packages > /opt/redislabs/lib/modules/python3/.venv/lib/python3.7/site-packages/global.pth

ADD redisedge.conf /etc
CMD ["/etc/redisedge.conf"]
