#----------------------------------------------------------------------------------------------
FROM raffapen/redisgears-arm:arm64-bionic as gears
# FROM redislabs/redisgears:arm64-bionic as gears

FROM raffapen/redis-arm:arm64-bionic as gears-opencv

SHELL ["/bin/bash", "-c"]

COPY --from=gears /opt/redislabs /opt/redislabs

ENV OPENCV_VERSION="4.1.0"

WORKDIR /opt

RUN \
	apt-get update; apt-get install -y \
	build-essential cmake git wget unzip yasm pkg-config \
	libswscale-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libavformat-dev libpq-dev

RUN \
	source /opt/redislabs/lib/modules/python3/.venv/bin/activate ;\
	pip install numpy

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
	cd opencv-${OPENCV_VERSION}/cmake_binary ;\
	make -j`nproc`

RUN \
	source /opt/redislabs/lib/modules/python3/.venv/bin/activate ;\
	cd opencv-${OPENCV_VERSION}/cmake_binary ;\
	make install

RUN \
	source /opt/redislabs/lib/modules/python3/.venv/bin/activate ;\
	apt-get install -y 	libjpeg-dev zlib1g-dev libtiff-dev ;\
	pip3 install Pillow ;\
	pip3 install imageio
	
#----------------------------------------------------------------------------------------------
FROM raffapen/redisai-arm:arm64-bionic as ai
FROM raffapen/redistimeseries-arm:arm64-bionic as timeseries

# FROM redislabs/redisai-arm:cpu-arm64-bionic as sai
# FROM redislabs/redistimeseries-arm:arm64-bionic as timeseries

#----------------------------------------------------------------------------------------------
FROM raffapen/redis-arm:arm64-bionic

# FROM redislabs/redis-arm:arm64-bionic

RUN apt-get update; apt-get install -y libgomp1

ENV LD_LIBRARY_PATH /usr/lib/redis/modules
WORKDIR /data
RUN set -ex ;\
    mkdir -p ${LD_LIBRARY_PATH}

COPY --from=timeseries ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/
COPY --from=ai ${LD_LIBRARY_PATH}/*.so* ${LD_LIBRARY_PATH}/
COPY --from=gears /opt/redislabs/lib/modules/redisgears.so ${LD_LIBRARY_PATH}/
COPY --from=gears-opencv /opt/redislabs /opt/redislabs

CMD ["--loadmodule", "/usr/lib/redis/modules/redistimeseries.so", \
     "--loadmodule", "/usr/lib/redis/modules/redisai.so", \
     "--loadmodule", "/usr/lib/redis/modules/redisgears.so", \
     "PythonHomeDir", "/opt/redislabs/lib/modules/python3/"]
