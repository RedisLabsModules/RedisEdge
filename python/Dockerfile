# BUILD redisfab/python:${VERSION}-${ARCH}-${OSNICK}

ARG VERSION=3.7.2

# OSNICK=bionic|stretch|buster
ARG OSNICK=bionic

# OS=debian:buster-slim|debian:stretch-slim|ubuntu:bionic
ARG OS=ubuntu:bionic

# ARCH=x64|arm64v8|arm32v7
ARG ARCH=arm64v8

#----------------------------------------------------------------------------------------------
FROM ${OS} AS builder

ARG VERSION
ARG OSNICK
ARG OS
ARG ARCH

RUN echo "Building for ${OSNICK} (${OS}) for ${ARCH}"

WORKDIR /build

ADD ./python/. . 
ADD ./deps/readies/ /build/deps/readies/

RUN ./deps/readies/bin/getpy2
RUN python2 ./system-setup.py

RUN git clone https://github.com/python/cpython.git
WORKDIR /build/cpython
RUN git checkout v${VERSION}

RUN ./configure
RUN make -j`nproc`
RUN make install
RUN python3 -m pip install --upgrade pip

#----------------------------------------------------------------------------------------------
FROM ${OS}

COPY --from=builder /usr/local/ /usr/local/

ENTRYPOINT ["/usr/local/bin/python3"]
