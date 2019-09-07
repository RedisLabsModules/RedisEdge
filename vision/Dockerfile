# BUILD redisfab/redisedgevision-${OSNICK}:M.m.b-${ARCH}

# OSNICK=stretch|bionic|buster
ARG OSNICK=buster

# ARCH=x64|arm64v8|arm32v7
ARG ARCH=x64

#----------------------------------------------------------------------------------------------
FROM redisfab/redisai-cpu-${OSNICK}:0.3.2 as ai
FROM redisfab/redistimeseries-${OSNICK}:1.0.2 as timeseries
FROM redisfab/redisgears-${OSNICK}:0.3.1 as gears
FROM redisfab/redisedgevisionlibs-${OSNICK}:0.1.2 as visionlibs

#----------------------------------------------------------------------------------------------
FROM redisfab/redis-${ARCH}-${OSNICK}:5.0.5

COPY deps/ deps/
ADD vision/system-setup.py .

RUN ./deps/readies/bin/getpy2
RUN python2 system-setup.py

WORKDIR /data

ENV REDISMODULES_LIBS /usr/lib/redis/modules
ENV LD_LIBRARY_PATH ${REDISMODULES_LIBS}:${LD_LIBRARY_PATH}
RUN mkdir -p ${REDISMODULES_LIBS}

COPY --from=timeseries ${REDISMODULES_LIBS}/*.so ${REDISMODULES_LIBS}/
COPY --from=ai         ${REDISMODULES_LIBS}/*.so* ${REDISMODULES_LIBS}/
COPY --from=gears      /opt/redislabs/lib/modules/redisgears.so ${REDISMODULES_LIBS}/
COPY --from=gears      /opt/redislabs/ /opt/redislabs/
COPY --from=visionlibs /usr/local/ /usr/local/

CMD ["--loadmodule", "/usr/lib/redis/modules/redistimeseries.so", \
     "--loadmodule", "/usr/lib/redis/modules/redisai.so", \
     "--loadmodule", "/usr/lib/redis/modules/redisgears.so", \
     "PythonHomeDir", "/opt/redislabs/lib/modules/python3/"]
