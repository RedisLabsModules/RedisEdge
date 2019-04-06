FROM redisai/redisai:latest as redisai
FROM redislabs/redistimeseries:latest as redistimeseries
FROM redislabs/redisgears:latest

ENV LD_LIBRARY_PATH /usr/lib/redis/modules
WORKDIR /data
RUN set -ex;\
    mkdir -p ${LD_LIBRARY_PATH};

COPY --from=redistimeseries ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/
COPY --from=redisai ${LD_LIBRARY_PATH}/*.so* ${LD_LIBRARY_PATH}/

CMD ["--loadmodule", "/usr/lib/redis/modules/redistimeseries.so", \
    "--loadmodule", "/usr/lib/redis/modules/redisai.so", \
    "--loadmodule", "/usr/lib/redis/modules/redisgears.so", \
    "PythonHomeDir", "/usr/lib/redis/modules/deps/cpython/"]
