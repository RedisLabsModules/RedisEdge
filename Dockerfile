#----------------------------------------------------------------------------------------------
FROM raffapen/redisai-arm:arm64-bionic as redisai
FROM raffapen/redistimeseries-arm:arm64-bionic as redistimeseries
FROM raffapen/redisgears-arm:arm64-bionic as redisgears

# FROM redislabs/redisai-arm:cpu-arm64-bionic as redisai
# FROM redislabs/redistimeseries:arm64-bionic as redistimeseries
# FROM redislabs/redisgears:arm64-bionic as redisgears

#----------------------------------------------------------------------------------------------
FROM FROM raffapen/redis-arm:arm64-bionic

# FROM redislabs/redis-arm:arm64-bionic

RUN apt-get update; apt-get install -y libgomp1

ENV LD_LIBRARY_PATH /usr/lib/redis/modules
WORKDIR /data
RUN set -ex;\
    mkdir -p ${LD_LIBRARY_PATH};

COPY --from=redistimeseries ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/
COPY --from=redisai ${LD_LIBRARY_PATH}/*.so* ${LD_LIBRARY_PATH}/
COPY --from=redisgears /opt/redislabs/lib/modules/redisgears.so ${LD_LIBRARY_PATH}/
COPY --from=redisgears /opt/redislabs /opt/redislabs

CMD ["--loadmodule", "/usr/lib/redis/modules/redistimeseries.so", \
     "--loadmodule", "/usr/lib/redis/modules/redisai.so", \
     "--loadmodule", "/usr/lib/redis/modules/redisgears.so", \
     "PythonHomeDir", "/opt/redislabs/lib/modules/python3/"]
