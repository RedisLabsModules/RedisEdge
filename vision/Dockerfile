# BUILD redisfab/redisedgevision:${VERSION}-${ARCH}-${OSNICK}

ARG VERSION=0.4.0

# OSNICK=stretch|bionic|buster
ARG OSNICK=bionic

# ARCH=x64|arm64v8|arm32v7
ARG ARCH=x64

# DEVICE=cpu|gpu
ARG DEVICE=cpu

ARG REDISAI_VERSION=1.0.2
ARG REDISTIMESERIES_VERSION=1.4.6
ARG REDISGEARS_VERSION=1.0.2
ARG REDIS_VER=6.2.1

# done to specifically allow for ease of optional override with --build-arg
ARG REDISAI_DOCKERDEP=${REDISAI_VERSION}-${DEVICE}-${ARCH}-${OSNICK}
ARG REDISTIMESERIES_DOCKERDEP=${REDISTIMESERIES_VERSION}-${ARCH}-${OSNICK}
ARG REDISGEARS_DOCKERDEP=${REDISGEARS_VERSION}-${ARCH}-${OSNICK}
ARG REDIS_DOCKERDEP=${REDIS_VER}-${ARCH}-${OSNICK}

#----------------------------------------------------------------------------------------------
FROM redisfab/redisai:${REDISAI_DOCKERDEP} as ai
FROM redisfab/redistimeseries:${REDISTIMESERIES_DOCKERDEP} as timeseries
FROM redisfab/redisgears:${REDISGEARS_DOCKERDEP} as gears

#----------------------------------------------------------------------------------------------
FROM redisfab/redisedge-pylibs:${VERSION}-${ARCH}-${OSNICK} as pylibs
FROM redisfab/redis:${REDIS_DOCKERDEP}

ARG OSNICK
ARG ARCH
ARG VERSION
ARG REDISAI_DOCKERDEP
ARG REDISTIMESERIES_DOCKERDEP
ARG REDISGEARS_DOCKERDEP
ARG REDIS_DOCKERDEP

RUN echo "Building redisedgevision:${VERSION}-${ARCH}-${OSNICK} with:" ;\
    echo "  RedisAI=${REDISAI_DOCKERDEP}" ;\
    echo "  RedisTimeSeries=${REDISTIMESERIES_DOCKERDEP}" ;\
    echo "  RedisGears=${REDISGEARS_DOCKERDEP}" ;\
    echo "  Redis=${REDIS_DOCKERDEP}"


COPY --from=pylibs /usr/local/ /usr/local/

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
COPY --from=gears      /var/opt/redislabs/lib/modules/redisgears.so ${REDISMODULES_LIBS}/
COPY --from=gears      /var/opt/redislabs/modules/ /var/opt/redislabs/modules/

# RUN set -e ;\
#    mkdir -p /var/opt/redislabs/modules/rg/python3/.venv/lib/python3.7/site-packages ;\
#    echo /usr/lib/python3/dist-packages > /var/opt/redislabs/modules/rg/python3/.venv/lib/python3.7/site-packages/global.pth

RUN set -e ;\
    mkdir -p /var/opt/redislabs/modules/rg/python3/lib/python3.7/site-packages ;\
	mkdir -p /var/opt/redislabs/modules/rg/python3/.venv/lib/python3.7/site-packages ;\
	echo /usr/local/lib/python3.7/site-packages > /var/opt/redislabs/modules/rg/python3/lib/python3.7/site-packages/local.pth ;\
	echo /usr/local/lib/python3.7/site-packages > /var/opt/redislabs/modules/rg/python3/.venv/lib/python3.7/site-packages/local.pth

ADD redisedge.conf /etc
ENTRYPOINT [ "/usr/local/bin/redis-server" ]
CMD ["/etc/redisedge.conf"]
