FROM redislabs/redistimeseries:latest as redistimeseries
FROM redisai/redisai:latest as redisai
FROM redisai/redisgears:latest as redisgears
FROM redis:latest as redis

ENV LD_LIBRARY_PATH /usr/lib/redis/modules
WORKDIR /data
RUN set -ex;\
    mkdir -p ${LD_LIBRARY_PATH};

COPY --from=redistimeseries ${LD_LIBRARY_PATH}/redistimeseries.so ${LD_LIBRARY_PATH}
COPY --from=redisgears ${LD_LIBRARY_PATH}/redisgears.so ${LD_LIBRARY_PATH}
COPY --from=redisai ${LD_LIBRARY_PATH}/redisai.so ${LD_LIBRARY_PATH}
COPY --from=redisai ${LD_LIBRARY_PATH}/libtensorflow.so ${LD_LIBRARY_PATH}
COPY --from=redisai ${LD_LIBRARY_PATH}/libtensorflow_framework.so ${LD_LIBRARY_PATH}

CMD ["--loadmodule", "/usr/lib/redis/modules/redistimeseries.so", \
    "--loadmodule", "/usr/lib/redis/modules/redisai.so" \
    "--loadmodule", "/usr/lib/redis/modules/redisgears.so"]
