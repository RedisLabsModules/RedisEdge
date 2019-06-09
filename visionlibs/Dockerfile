# BUILD redislabs/redisedgevisionlibs-${ARCH}-${OSNICK}:latest

FROM python:3.7

SHELL ["/bin/bash", "-c"]

ENV OPENCV_VERSION="4.1.0"

WORKDIR /build

COPY deps/ deps/
ADD visionlibs/system-setup.py .

RUN ./deps/readies/bin/getpy2
RUN python2 system-setup.py

ENV PYENV=/opt/redislabs/edgevision

RUN set -ex ;\
	mkdir -p $PYENV ;\
	virtualenv $PYENV

RUN source $PYENV/bin/activate ;\
	pip3 install numpy

RUN set -ex ;\
	wget --quiet https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip ;\
	unzip -q ${OPENCV_VERSION}.zip

RUN source $PYENV/bin/activate ;\
	mkdir -p opencv-${OPENCV_VERSION}/cmake_binary ;\
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

RUN source $PYENV/bin/activate ;\
	cd opencv-${OPENCV_VERSION}/cmake_binary ;\
	make -j`nproc`

RUN source $PYENV/bin/activate ;\
	cd opencv-${OPENCV_VERSION}/cmake_binary ;\
	make install

RUN set -ex ;\
	source $PYENV/bin/activate ;\
	pip3 install Pillow ;\
	pip3 install imageio
