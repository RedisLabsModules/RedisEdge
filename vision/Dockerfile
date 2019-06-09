# TAG raffapen/redisedgevision-${ARCH}-${OSNICK}:latest

ARG OSNICK=bionic
# ARG ARCH=x64|arm64|arm7l

#----------------------------------------------------------------------------------------------
FROM raffapen/redisai-cpu-${OSNICK}:latest as ai
FROM raffapen/redistimeseries-${OSNICK}:latest as timeseries 
FROM raffapen/redisgears-${OSNICK}:latest as gears
FROM raffapen/redisedgevisionlibs-${OSNICK}:latest as visionlibs

#----------------------------------------------------------------------------------------------
FROM raffapen/redis-${OSNICK}:5.0.5

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
COPY --from=visionlibs /opt/redislabs/ /opt/redislabs/
# COPY --from=visionlibs /usr/local/ /usr/local/

RUN echo /opt/redislabs/edgevision/lib/python3.7/site-packages > /opt/redislabs/lib/modules/python3/.venv/lib/python3.7/site-packages/edgevision.pth

CMD ["--loadmodule", "/usr/lib/redis/modules/redistimeseries.so", \
     "--loadmodule", "/usr/lib/redis/modules/redisai.so", \
     "--loadmodule", "/usr/lib/redis/modules/redisgears.so", \
     "PythonHomeDir", "/opt/redislabs/lib/modules/python3/"]
