[![CircleCI](https://circleci.com/gh/RedisLabs/RedisEdge/tree/master.svg?style=svg)](https://circleci.com/gh/RedisLabs/RedisEdge/tree/master)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/redislabs/redisedge.svg)](https://hub.docker.com/r/redislabs/redisedge/builds/)

# redisedge - a Docker image with select Redis Labs modules for the Edge

This container image bundles together [Redis](https://redis.io) with Redis modules from [Redis Labs](https://redislabs.com) for Edge computing.

# Quickstart

```text
$ $ docker run -it -p 6379:6379 redisedge
1:C 22 May 2019 21:03:43.669 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
1:C 22 May 2019 21:03:43.669 # Redis version=5.0.5, bits=64, commit=00000000, modified=0, pid=1, just started
1:C 22 May 2019 21:03:43.669 # Configuration loaded
...
1:M 22 May 2019 21:03:43.789 * Module 'ai' loaded from /usr/lib/redis/modules/redisai.so
loaded default MAX_SAMPLE_PER_CHUNK policy: 360
1:M 22 May 2019 21:03:43.789 * Module 'timeseries' loaded from /usr/lib/redis/modules/redistimeseries.so
1:M 22 May 2019 21:03:43.791 * <rg> RedisGears version 0.3.1, git_sha=be5c5fcdf2abaabe5ff62155d9c38e0ecaa97575
1:M 22 May 2019 21:03:43.791 * <rg> PythonHomeDir:/opt/redislabs/lib/modules/python3
1:M 22 May 2019 21:03:43.791 * <rg> MaxExecutions:1000
1:M 22 May 2019 21:03:43.791 * <rg> ProfileExecutions:0
1:M 22 May 2019 21:03:43.791 * <rg> PythonAttemptTraceback:1
1:M 22 May 2019 21:03:43.791 * <rg> RedisAI api loaded successfully.
could not initialize RediSearch_CheckApiVersionCompatibility
1:M 22 May 2019 21:03:43.791 # <rg> could not initialize RediSearch api, running without Search support.
1:M 22 May 2019 21:03:43.804 * <rg> Initializing Python environment with: exec(open('/opt/redislabs/lib/modules/python3/.venv/bin/activate_this.py').read(), {'__file__': '/opt/redislabs/lib/modules/python3/.venv/bin/activate_this.py'})
1:M 22 May 2019 21:03:43.840 * Module 'rg' loaded from /opt/redislabs/lib/modules/redisgears.so
1:M 22 May 2019 21:03:43.840 * Ready to accept connections
```

## Modules included in the container

* [RedisTimeSeries](https://oss.redislabs.com/redistimeseries/): a timeseries database
* [RedisAI](https://oss.redislabs.com/redisai/): a tensor and deep learning graphs server
* [RedisGears](https://oss.redislabs.com/redisgears/): a dynamic execution framework

## Configuring the Redis server

This image is based on the [official image of Redis from Docker](https://hub.docker.com/_/redis/). By default, the container starts with Redis' default configuration and all included modules loaded.

You can, of course, override the defaults. This can be done either by providing additional command line arguments to the `docker` command, or by providing your own [Redis configuration file](http://download.redis.io/redis-stable/redis.conf).

### Running the container with command line arguments

You can provide Redis with configuration directives directly from the `docker` command. For example, the following will start the container, mount the host's `/home/user/data` volume to the container's `/data`, load the RedisAI module, and configure Redis' working directory to `/data` so that the data will actually be persisted there.

```text
$ docker run \
  -p 6379:6379 \
  -v /home/user/data:/data \
  redislabs/redisedge \
  --loadmodule /usr/lib/redis/modules/redisai.so \
  --dir /data
```

### Running the container with a custom configuration file

This image uses a custom configuration file (located at `/etc/redisedge.conf`. You can use that as a starting point for putting together your own and store it somewhere like `/home/user/myredisedge.conf`. You can then load the container with the custom configuration file likeso:

```text
$ docker run \
  -p 6379:6379 \
  -v /home/user/data:/data \
  -v /home/user/myredisedge.conf:/usr/local/etc/redisedge.conf \
  redislabs/redisedge \
  /usr/local/etc/redisedge.conf
```

## License

This Docker image is licensed under the [Redis Source Available License](https://github.com/RedisLabsModules/licenses/).

