# BUILD redisfab/redisedge-pylibs:${VERSION}-${ARCH}-${OSNICK}

ARG VERSION=0.4.0

# OS=debian:buster-slim|debian:stretch-slim|ubuntu:bionic|ubuntu:focal
ARG OS=ubuntu:bionic

# OSNICK=stretch|bionic|buster
ARG OSNICK=bionic

# ARCH=x64|arm64v8
ARG ARCH=x64

ARG PY_VER=3.7.2

#----------------------------------------------------------------------------------------------
FROM redisfab/python:${PY_VER}-${ARCH}-${OSNICK}

# The Python distribution is installed into /usr/local/bin.
# The Python interpreter uses libpython3.7m.so.1.0, which is installed into /usr/local/lib.
# Any libraries built and installed here are installed into /usr/local/lib.

SHELL ["/bin/bash", "-c"]

ENV OPENCV_VERSION="4.4.0"

WORKDIR /build

COPY deps/ deps/
ADD pylibs/system-setup.py .

RUN python3 system-setup.py

#----------------------------------------------------------------------------------------------

RUN python3 -m pip install numpy

#----------------------------------------------------------------------------------------------

RUN set -ex ;\
    wget --quiet https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip ;\
    unzip -q ${OPENCV_VERSION}.zip

RUN mkdir -p opencv-${OPENCV_VERSION}/cmake_binary ;\
    cd opencv-${OPENCV_VERSION}/cmake_binary ;\
    cmake \
        -D BUILD_TIFF=ON \
        -D BUILD_opencv_java=OFF \
        -D WITH_CUDA=OFF \
        -D WITH_OPENGL=ON \
        -D WITH_OPENCL=ON \
        -D WITH_IPP=ON \
        -D WITH_TBB=ON \
        -D WITH_EIGEN=ON \
        -D WITH_V4L=ON \
        -D BUILD_TESTS=OFF \
        -D BUILD_PERF_TESTS=OFF \
        \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=$(python3.7 -c "import sys; print(sys.prefix)") \
        \
        -D BUILD_PYTHON_SUPPORT=yes \
        -D BUILD_NEW_PYTHON_SUPPORT=yes \
        -D PYTHON_EXECUTABLE=$(which python3.7) \
        -D PYTHON_INCLUDE_DIR=$(python3.7 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
        -D PYTHON_PACKAGES_PATH=$(python3.7 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
        -D PYTHON_DEFAULT_EXECUTABLE=$(which python3.7) \
        -D PYTHON_LIBRARY=$(python3 -c "from distutils.sysconfig import get_config_var;from os.path import dirname,join ; print(join(dirname(get_config_var('LIBPC')),get_config_var('LDLIBRARY')))") \
        -D PYTHON3_NUMPY_INCLUDE_DIRS:PATH=$(python3.7 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")/numpy/core/include \
        -D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
        \
        ..

RUN cd opencv-${OPENCV_VERSION}/cmake_binary ;\
    make -j`nproc`

RUN cd opencv-${OPENCV_VERSION}/cmake_binary ;\
    make install

#----------------------------------------------------------------------------------------------

RUN set -ex ;\
    python3 -m pip install Pillow ;\
    python3 -m pip install imageio
