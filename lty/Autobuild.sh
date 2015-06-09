#!/bin/sh
#add by joey

set -e

if [ `id -u` -ne 0 ];then
	echo "must use root user!"
	exit 0
fi

ROOT_DIR=$(pwd)

echo "install cross toolchain"
pushd osdrv/toolchain/arm-hisiv100nptl-linux/;	chmod +x cross.install;./cross.install;	popd

source /etc/profile

echo "compiling OSDRV"
pushd osdrv/;	make OSDRV_CROSS=arm-hisiv100nptl-linux all;	popd

echo "compiling app"
echo "compiling hostapd and wpa_supplicant"
pushd $ROOT_DIR/APP/hostap/hostapd/;	make;	popd
pushd $ROOT_DIR/APP/hostap/wpa_supplicant/;	make;	popd

echo "compiling iw"
pushd $ROOT_DIR/APP/iw-3.17/;	make; popd

echo "compiling iproute2"
pushd $ROOT_DIR/APP/iproute2-3.19.0/;	make; popd

echo "compiling iptables"
pushd $ROOT_DIR/APP/iptables-1.4.21
./configure --host=arm-hisiv100nptl-linux --prefix=$ROOT_DIR/APP/iptables-1.4.21/my --enable-static --disable-shared
make KERNEL_DIR=$ROOT_DIR/osdrv/kernel/linux-3.0.y
make;make install;popd

echo "compiling lighttpd"
pushd $ROOT_DIR/APP/lighttpd-1.4.18
./configure -prefix=$ROOT_DIR/APP/lighttpd-1.4.18/my -disable-ipv6 -host=arm-hisiv100nptl-linux
make;make install;popd

echo "compiling PHP"
pushd $ROOT_DIR/APP/php-5.5.21
./configure --prefix=$ROOT_DIR/APP/php-5.5.21/my --host=arm-hisiv100nptl-linux --disable-all
make;make install;popd

echo "compiling dnsmasq"
pushd $ROOT_DIR/APP/dnsmasq-2.72;	make;make install;popd

