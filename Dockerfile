FROM redislabs/redistimeseries:latest as redistimeseries
FROM redisai/redisai:latest as redisai

FROM redis:5.0.3 as redis
ENV LD_LIBRARY_PATH /usr/lib/redis/modules
WORKDIR ${LD_LIBRARY_PATH};

COPY --from=redistimeseries ${LD_LIBRARY_PATH}/redistimeseries.so ${LD_LIBRARY_PATH}
COPY --from=redisai ${LD_LIBRARY_PATH}/*.so* ${LD_LIBRARY_PATH}

WORKDIR /data
CMD ["--loadmodule", "/usr/lib/redis/modules/redistimeseries.so", \
    "--loadmodule", "/usr/lib/redis/modules/redisai.so"]
