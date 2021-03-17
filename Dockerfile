# BUILD redisfab/redisedge-${OSNICK}:${VERSION}-${ARCH}
ARG VERSION=latest

# ARCH=x64|arm64v8|arm32v7
ARG ARCH=x64
ARG REDISAI_VARIANT=cpu

ARG REDISAI_VERSION=edge
ARG REDISTIMESERIES_VERSION=edge
ARG REDISGEARS_VERSION=edge
ARG REDIS_VERSION=latest

#----------------------------------------------------------------------------------------------
FROM redislabs/redisai:${REDISAI_VERSION}-${REDISAI_VARIANT} as ai
FROM redislabs/redistimeseries:${REDISTIMESERIES_VERSION} as timeseries
FROM redislabs/redisgears:${REDISGEARS_VERSION} as gears
FROM redislabs/redis:${REDIS_VERSION} as redis

#----------------------------------------------------------------------------------------------
FROM redislabs/redis:${REDIS_VERSION}

ARG VERSION
ARG REDISAI_VERSION
ARG REDISTIMESERIES_VERSION
ARG REDISGEARS_VERSION

USER root
ADD /sudoers.txt /etc/sudoers
RUN chmod 440 /etc/sudoers
RUN echo "Building redisedge with RedisAI=${REDISAI_VERSION}  RedisTimeSeries=${REDISTIMESERIES_VERSION} RedisGears=${REDISGEARS_VERSION}"
RUN id

RUN set -e ;\
	sudo apt-get -qq update && sudo apt-get -q install -y libgomp1

ENV LIBDIR /usr/lib/redis/modules
ENV LD_LIBRARY_PATH $LIBDIR
WORKDIR /data
RUN sudo mkdir -p ${LIBDIR}

COPY --from=timeseries ${LIBDIR}/*.so ${LIBDIR}/
COPY --from=ai         ${LIBDIR}/ ${LIBDIR}/
COPY --from=gears      /var/opt/redislabs/lib/modules/redisgears.so ${LIBDIR}/
COPY --from=gears      /var/opt/redislabs/ /opt/redislabs/

ADD redisedge.conf /etc
CMD sudo rm -f /etc/sudoers

USER redislabs
CMD ["/etc/redisedge.conf"]
