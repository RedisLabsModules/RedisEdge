#----------------------------------------------------------------------------------------------
FROM raffapen/redisai-arm:arm64-bionic as redisai
FROM raffapen/redistimeseries-arm:arm64-bionic as redistimeseries
FROM raffapen/redisgears-arm:arm64-bionic as redisgears

# FROM redislabs/redisai-arm:cpu-arm64-bionic as redisai
# FROM redislabs/redistimeseries:arm64-bionic as redistimeseries
# FROM redislabs/redisgears:arm64-bionic as redisgears

#----------------------------------------------------------------------------------------------
FROM raffapen/redis-arm:arm64-bionic as opencv

COPY --from=redisgears /opt/redislabs /opt/redislabs

RUN apt-get update; apt-get install -y \
	build-essential cmake git wget unzip yasm pkg-config \
	libswscale-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libavformat-dev libpq-dev

RUN pip install numpy

WORKDIR /opt

ENV OPENCV_VERSION="4.1.0"

RUN \
	wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip ;\
	unzip ${OPENCV_VERSION}.zip

RUN \
	source /opt/redislabs/lib/modules/python3/.venv/bin/activate ;\
	mkdir -p opencv-${OPENCV_VERSION}/cmake_binary ;\
	cd opencv-${OPENCV_VERSION}/cmake_binary ;\
	cmake -DBUILD_TIFF=ON \
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
		-D CMAKE_BUILD_TYPE=RELEASE \
		\
		-D CMAKE_INSTALL_PREFIX=$(python3.7 -c "import sys; print(sys.prefix)") \
		-D PYTHON_EXECUTABLE=$(which python3.7) \
		-D PYTHON_INCLUDE_DIR=$(python3.7 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
		-D PYTHON_PACKAGES_PATH=$(python3.7 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
		-D PYTHON_DEFAULT_EXECUTABLE=$(which python3.7) \
		-D PYTHON3_NUMPY_INCLUDE_DIRS:PATH=$(python3.7 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")/numpy/core/include \
		-D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
		-D BUILD_PYTHON_SUPPORT=yes \
		-D BUILD_NEW_PYTHON_SUPPORT=yes \
		-D PYTHON_LIBRARY=$(python3 -c "from distutils.sysconfig import get_config_var;from os.path import dirname,join ; print(join(dirname(get_config_var('LIBPC')),get_config_var('LDLIBRARY')))") \
		..
RUN \
	source /opt/redislabs/lib/modules/python3/.venv/bin/activate ;\
	make -j`nproc`

RUN \
	source /opt/redislabs/lib/modules/python3/.venv/bin/activate ;\
	make install

#----------------------------------------------------------------------------------------------
FROM raffapen/redis-arm:arm64-bionic

# FROM redislabs/redis-arm:arm64-bionic

RUN apt-get update; apt-get install -y libgomp1

ENV LD_LIBRARY_PATH /usr/lib/redis/modules
WORKDIR /data
RUN set -ex;\
    mkdir -p ${LD_LIBRARY_PATH};

COPY --from=redistimeseries ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/
COPY --from=redisai ${LD_LIBRARY_PATH}/*.so* ${LD_LIBRARY_PATH}/
COPY --from=redisgears /opt/redislabs/lib/modules/redisgears.so ${LD_LIBRARY_PATH}/
COPY --from=opencv /opt/redislabs /opt/redislabs

CMD ["--loadmodule", "/usr/lib/redis/modules/redistimeseries.so", \
     "--loadmodule", "/usr/lib/redis/modules/redisai.so", \
     "--loadmodule", "/usr/lib/redis/modules/redisgears.so", \
     "PythonHomeDir", "/opt/redislabs/lib/modules/python3/"]
