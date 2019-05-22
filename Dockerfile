FROM redisai/redisai:latest as redisai
FROM redislabs/redistimeseries:latest as redistimeseries
FROM redislabs/redisgears:latest

ENV LD_LIBRARY_PATH /usr/lib/redis/modules
RUN set -ex;\
    mkdir -p ${LD_LIBRARY_PATH};

COPY --from=redistimeseries ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/
COPY --from=redisai ${LD_LIBRARY_PATH}/*.so* ${LD_LIBRARY_PATH}/

ADD redisedge.conf /etc
CMD ["/etc/redisedge.conf"]
