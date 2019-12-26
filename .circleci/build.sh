#!/usr/bin/env bash
sudo apt-get update -y
sudo apt-get install -y ccache bc bash git-core gnupg build-essential zip curl make automake autogen autoconf autotools-dev libtool shtool python m4 gcc libtool zlib1g-dev dash 
cd /
git clone  https://github.com/dracarys18/NotKernel.git -b pie mido --depth 1
git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 -b android-10.0.0_r20 gcc32 --depth 1 
git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 -b android-10.0.0_r20 gcc --depth 1
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=/gcc/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=/gcc32/bin/arm-linux-androideabi-
cd mido
 make  O=out ARCH=arm64 mido_defconfig
make -j16 O=out 


              
        
			
	
