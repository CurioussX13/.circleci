#!/usr/bin/env bash
apt-get update -y
sudo apt-get install -y ccache bc bash git-core gnupg build-essential zip curl make automake autogen autoconf autotools-dev libtool shtool python m4 gcc libtool zlib1g-dev dash
cd /
git clone https://github.com/NusantaraDevs/clang --depth=1 -b dev/10.0 clang
git clone https://github.com/Nicklas373/kernel_xiaomi_msm8953-3.18-2 -b dev/kasumi-10 mido --depth 1
export ARCH=arm64
export SUBARCH=arm64
export LD_LIBRARY_PATH=/clang/lib
export CLANG_TRIPLE=/clang/bin/aarch64-linux-gnu-
export CLANG_TRIPLE_ARM32=/clang/bin/arm-linux-gnueabi-
export CROSS_COMPILE=/clang/bin/aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=/clang/bin/arm-linux-gnueabi-
export CC=/clang/bin/clang
	cd mido
        make  O=out ARCH=arm64 mido_defconfig
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=/clang/bin/clang \
                    CLANG_TRIPLE=/clang/bin/aarch64-linux-gnu- \
CLANG_TRIPLE_ARM32=/clang/bin/arm-linux-gnueabi- \
 CROSS_COMPILE=/clang/bin/aarch64-linux-gnu- \
CROSS_COMPILE_ARM32=/clang/bin/arm-linux-gnueabi-



        
			
	
