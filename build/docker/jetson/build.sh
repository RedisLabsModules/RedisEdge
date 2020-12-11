# BUILD redisfab/jetson-jetpack:$(VERSION)-$(MODEL)-arm64v8-$(OSNICK)

cp -RP /xetc/alternatives/cud*    /etc/alternatives/
cp -RP /xetc/alternatives/libcud* /etc/alternatives/
cp -RP /xetc/alternatives/libmpi* /etc/alternatives/
cp -RP /xetc/alternatives/vpi*    /etc/alternatives/

mkdir -p /xetc/ld.so.conf.d
cp -RP /xetc/ld.so.conf.d/cuda-10-2.conf    /etc/ld.so.conf.d/
cp -RP /xetc/ld.so.conf.d/nvidia-tegra.conf /etc/ld.so.conf.d/

mkdir -p /usr/include/aarch64-linux-gnu/ /usr/include/hwloc

cp -RP /xusr/include/aarch64-linux-gnu/Nv*  /usr/include/aarch64-linux-gnu/
cp -RP /xusr/include/aarch64-linux-gnu/cud* /usr/include/aarch64-linux-gnu/

cp -RP /xusr/include/cub*       /usr/include/
cp -RP /xusr/include/cud*       /usr/include/
cp -RP /xusr/include/NVX/       /usr/include/NVX/
cp -RP /xusr/include/hwloc/cud* /usr/include/hwloc/

cp -RP /xusr/local/cuda-10.2/ /usr/local/cuda-10.2/
(cd /usr/local; ln -sf cuda-10.2 cuda)

cp -RP /xusr/lib/libmpi* /usr/lib/

cp -RP /xusr/lib/aarch64-linux-gnu/libcublas.so /usr/lib/aarch64-linux-gnu/
cp -RP /xusr/lib/aarch64-linux-gnu/tegra/       /usr/lib/aarch64-linux-gnu/tegra/
cp -RP /xusr/lib/aarch64-linux-gnu/tegra-egl/   /usr/lib/aarch64-linux-gnu/tegra-egl/
cp -RP /xusr/lib/aarch64-linux-gnu/libcud*      /usr/lib/aarch64-linux-gnu/
cp -RP /xusr/lib/aarch64-linux-gnu/libcub*      /usr/lib/aarch64-linux-gnu/
cp -RP /xusr/lib/aarch64-linux-gnu/openmpi/     /usr/lib/aarch64-linux-gnu/openmpi/
cp -RP /xusr/lib/aarch64-linux-gnu/libmpi*      /usr/lib/aarch64-linux-gnu/
cp -RP /xusr/lib/aarch64-linux-gnu/libopen-*    /usr/lib/aarch64-linux-gnu/

cp -RP /xopt/nvidia/ /opt/
