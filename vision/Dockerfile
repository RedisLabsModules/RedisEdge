# BUILD redisfab/redisedgevision-${OSNICK}:M.m.b-${ARCH}

# OSNICK=stretch|bionic|buster
ARG OSNICK=buster

# ARCH=x64|arm64v8|arm32v7
ARG ARCH=x64

#----------------------------------------------------------------------------------------------
FROM redisfab/redisai-cpu-${OSNICK}:0.3.1 as ai
FROM redisfab/redistimeseries-${OSNICK}:1.0.2 as timeseries
FROM redisfab/redisgears-${OSNICK}:0.3.1 as gears
# FROM redisfab/redisedgevisionlibs-${OSNICK}:0.1.2 as visionlibs

#----------------------------------------------------------------------------------------------
FROM redisfab/redis-${ARCH}-${OSNICK}:5.0.5

WORKDIR /tmp

COPY deps/ deps/
ADD vision/system-setup.py .

RUN ./deps/readies/bin/getpy
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
