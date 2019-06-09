# BUILD raffapen/redisedge-${ARCH}-${OSNICK}:latest

ARG OSNICK=bionic

#----------------------------------------------------------------------------------------------
FROM raffapen/redisai-cpu-${OSNICK}:latest as ai
FROM raffapen/redistimeseries-${OSNICK}:latest as timeseries 
FROM raffapen/redisgears-${OSNICK}:latest as gears

#----------------------------------------------------------------------------------------------
FROM raffapen/redis-${OSNICK}:5.0.5

RUN apt-get update; apt-get install -y libgomp1

ENV LD_LIBRARY_PATH /usr/lib/redis/modules
WORKDIR /data
RUN mkdir -p ${LD_LIBRARY_PATH};

COPY --from=redistimeseries ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/
COPY --from=redisai ${LD_LIBRARY_PATH}/*.so* ${LD_LIBRARY_PATH}/
COPY --from=redisgears /opt/redislabs/lib/modules/redisgears.so ${LD_LIBRARY_PATH}/
COPY --from=redisgears /opt/redislabs /opt/redislabs

CMD ["--loadmodule", "/usr/lib/redis/modules/redistimeseries.so", \
     "--loadmodule", "/usr/lib/redis/modules/redisai.so", \
     "--loadmodule", "/usr/lib/redis/modules/redisgears.so", \
     "PythonHomeDir", "/opt/redislabs/lib/modules/python3/"]
