#!/bin/bash

# 0 = Clang 10.0.0 (Pendulum Clang)
# 1 = Clang 10.0.0 (LiuNian Clang 10.0.0)
# 2 = Clang 10.0.0 (Proton Clang 10.0.0)
# 3 = Clang 10.0.3 + (GCC 4.9 Non-elf 32/64)
# 4 = Clang 11.0.0 (Nusantara Clang)
# 5 = Clang 11.0.0 (Proton Clang prebuilt 202001017)
# 6 = Clang 11.0.0 (LiuNian clang 2020/01/18-2)

export ARCH=arm64
export KBUILD_BUILD_USER=Dev
export KBUILD_BUILD_HOST=${KERNEL_BOT}
export TELEGRAM_SUCCESS="CAADAgADDSMAAuCjggeXsvhpxp-R4xYE"
export TELEGRAM_FAIL="CAADAgADAiMAAuCjggeCh9mRFWEJ9RYE"
IMAGE="$(pwd)/kernel/out/arch/arm64/boot/Image.gz-dtb"
KERNEL="$(pwd)/kernel"
KERNEL_TEMP="$(pwd)/TEMP"
CODENAME="mido"
KERNEL_CODE="Mido"
TELEGRAM_DEVICE="Xiaomi Redmi Note 4x"
KERNEL_REV="r1"
KERNEL_NAME="ThyK"
KERNEL_SUFFIX="Kernel"
KERNEL_DATE="$(date +%Y%m%d-%H%M)"
KERNEL_ANDROID_VER="9-10"
KERNEL_TAG="P-Q"
KERNEL_RELEASE="Stable"
KERNEL_RELEASE="BETA"
KERNEL_COMPILER="1"
TELEGRAM_BOT_ID=$(openssl enc -base64 -d <<< OTk0MzkyMzY3OkFBRk9ZUS04aXZKUklLQTR2MEJQTGJuV3B0M1hWejNJSXFz )
TELEGRAM_GROUP_ID=$(openssl enc -base64 -d <<< LTEwMDEzMTM2MDAxMDY= )
KERNEL_BOT="Circle-CI"
TELEGRAM_FILENAME="${KERNEL_NAME}-${KERNEL_SUFFIX}-${KERNEL_CODE}-${KERNEL_REV}-${KERNEL_TAG}-${KERNEL_DATE}.zip"

mkdir TEMP
git clone --depth=1 git://github.com/CurioussX13/ThyK -b master kernel
git clone --depth=1 git://github.com/CurioussX13/AnyKernel3 -b mido
if [ "$KERNEL_COMPILER" == "0" ];
	then
		git clone --depth=1 https://github.com/Haseo97/Clang-10.0.0 -b clang-10.0.0 clang-2
elif [ "$KERNEL_COMPILER" == "1" ];
	then
		git clone --depth=1 https://github.com/HANA-CI-Build-Project/LiuNian-clang -b clang-10 l-clang
elif [ "$KERNEL_COMPILER" == "2" ];
	then
		git clone --depth=1 https://github.com/HANA-CI-Build-Project/proton-clang -b master p-clang
elif [ "$KERNEL_COMPILER" == "3" ];
	then
		echo "Use latest AOSP Clang & GCC 4.9 From Najahii Oven"
elif [ "$KERNEL_COMPILER" == "4" ];
	then
		echo "Use latest nusantara clang"
elif [ "$KERNEL_COMPILER" == "5" ];
        then
                git clone --depth=1 https://github.com/HANA-CI-Build-Project/proton-clang -b proton-clang-11 p-clang
elif [ "$KERNEL_COMPILER" == "6" ];
	then
		git clone --depth=1 https://github.com/HANA-CI-Build-Project/LiuNian-clang -b master l-clang
fi

if [ "$KERNEL_COMPILER" == "0" ];
	then
		export CLANG_PATH=$(pwd)/clang-2/bin
		export PATH=${CLANG_PATH}:${PATH}
		export LD_LIBRARY_PATH="$(pwd)/clang-2/bin/../lib:$PATH"
elif [ "$KERNEL_COMPILER" == "1" ] || [ "$KERNEL_COMPILER" == "6" ];
	then
		export CLANG_PATH=$(pwd)/l-clang/bin
                export PATH=${CLANG_PATH}:${PATH}
		export LD_LIBRARY_PATH="$(pwd)/l-clang-2/bin/../lib:$PATH"
elif [ "$KERNEL_COMPILER" == "2" ] || [ "$KERNEL_¹COMPILER" == "5" ];
	then
		export CLANG_PATH=$(pwd)/p-clang/bin
                export PATH=${CLANG_PATH}:${PATH}
		export LD_LIBRARY_PATH="$(pwd)/p-clang/bin/../lib:$PATH"
elif [ "$KERNEL_COMPILER" == "3" ]
	then
		export CLANG_PATH=/root/aosp-clang/bin
		export PATH=${CLANG_PATH}:${PATH}
		export LD_LIBRARY_PATH="/root/aosp-clang/bin/../lib:$PATH"
		export CROSS_COMPILE=/root/gcc-4.9/arm64/bin/aarch64-linux-android-
		export CROSS_COMPILE_ARM32=/root/gcc-4.9/arm/bin/arm-linux-androideabi-
elif [ "$KERNEL_COMPILER" == "4" ]
	then
		export LD_LIBRARY_PATH="root/clang/bin/../lib:$PATH"
fi

function bot_env() {
TELEGRAM_KERNEL_VER=$(cat ${KERNEL}/out/.config | grep Linux/arm64 | cut -d " " -f3)
TELEGRAM_UTS_VER=$(cat ${KERNEL}/out/include/generated/compile.h | grep UTS_VERSION | cut -d '"' -f2)
TELEGRAM_COMPILER_NAME=$(cat ${KERNEL}/out/include/generated/compile.h | grep LINUX_COMPILE_BY | cut -d '"' -f2)
TELEGRAM_COMPILER_HOST=$(cat ${KERNEL}/out/include/generated/compile.h | grep LINUX_COMPILE_HOST | cut -d '"' -f2)
TELEGRAM_TOOLCHAIN_VER=$(cat ${KERNEL}/out/include/generated/compile.h | grep LINUX_COMPILER | cut -d '"' -f2)
}

function bot_template() {
curl -s -X POST https://api.telegram.org/bot${TELEGRAM_BOT_ID}/sendMessage -d chat_id=${TELEGRAM_GROUP_ID} -d "parse_mode=HTML" -d text="$(
            for POST in "${@}"; do
                echo "${POST}"
            done
          )"
}

function bot_first_compile() {
bot_template  "<b>Latest commit:</b><code> $(git --no-pager log --pretty=format:'"%h - %s (%an)"' -1)</code>" \
              "" \
	      "<b>${KERNEL_NAME} Kernel build Start!</b>" \
	     
 	      }
		function bot_complete_compile() {
		bot_env
		bot_template  "<b>|| ${KERNEL_BOT} Build Bot ||</b>" \
    		"" \
    		"<b>New ${KERNEL_NAME} Kernel Build Is Available!</b>" \
    		"" \
    		"<b>Build Status :</b><code> ${KERNEL_RELEASE} </code>" \
    		"<b>Device :</b><code> ${TELEGRAM_DEVICE} </code>" \
    		"<b>Android Version :</b><code> ${KERNEL_ANDROID_VER} </code>" \
    		"<b>Filename :</b><code> ${TELEGRAM_FILENAME}</code>" \
    		"<b>Kernel Version:</b><code> Linux ${TELEGRAM_KERNEL_VER}</code>" \
    		"<b>Kernel Host:</b><code> ${TELEGRAM_COMPILER_NAME}@${TELEGRAM_COMPILER_HOST}</code>" \
    		"<b>Kernel Toolchain :</b><code> ${TELEGRAM_TOOLCHAIN_VER}</code>" \
    		"<b>UTS Version :</b><code> ${TELEGRAM_UTS_VER}</code>" \
    		"<b>Latest commit :</b><code> $(git --no-pager log --pretty=format:'"%h - %s (%an)"' -1)</code>" \
    		"<b>Compile Time :</b><code> $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s)</code>" \
    		"" \
    		"<b>                         proJTHy                   </b>"
		}

function bot_build_success() {
bot_template  "<b>|| ${KERNEL_BOT} Build Bot ||</b>" \
              "" \
	      "<b>${KERNEL_NAME} Kernel build Success!</b>"
}

function bot_build_failed() {
bot_template "<b>|| ${KERNEL_BOT} Build Bot ||</b>" \
              "" \
	      "<b>${KERNEL_NAME} Kernel build Failed!</b>" \
              "" \
              "<b>Compile Time :</b><code> $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s)</code>"
}

function sendStick() {
	curl -s -X POST https://api.telegram.org/bot$TELEGRAM_BOT_ID/sendSticker -d sticker="${1}" -d chat_id=$TELEGRAM_GROUP_ID &>/dev/null
}

function compile() {
	
			cd ${KERNEL}
			bot_first_compile
			START=$(date +"%s")
			make ARCH=arm64 mido_defconfig O=out 
		if [ "$KERNEL_COMPILER" == "0" ];
			then
				PATH="$(pwd)/clang-2/bin/:${PATH}" \
        			make -C ${KERNEL} -j$(nproc --all) -> ${KERNEL_TEMP}/compile.log O=out \
								CC=clang \
								CLANG_TRIPLE=aarch64-linux-gnu- \
		        					CROSS_COMPILE=aarch64-linux-gnu- \
								CROSS_COMPILE_ARM32=arm-linux-gnueabi-
		elif [ "$KERNEL_COMPILER" == "1" ] || [ "$KERNEL_COMPILER" == "6" ];
			then
				PATH="$(pwd)/l-clang/bin/:${PATH}" \
				make -C ${KERNEL} -j$(nproc --all) -> ${KERNEL_TEMP}/compile.log O=out \
								CC=clang \
                                                                CLANG_TRIPLE=aarch64-linux-gnu- \
								CROSS_COMPILE=aarch64-linux-gnu- \
								CROSS_COMPILE_ARM32=arm-linux-gnueabi-
		elif [ "$KERNEL_COMPILER" == "2" ] || [ "$KERNEL_COMPILER" == "5" ];
			then
				PATH="$(pwd)/p-clang/bin/:${PATH}" \
				make -C ${KERNEL} -j$(nproc --all) -> ${KERNEL_TEMP}/compile.log O=out \
								CC=clang \
								CLANG_TRIPLE=aarch64-linux-gnu- \
								CROSS_COMPILE=aarch64-linux-gnu- \
								CROSS_COMPILE_ARM32=arm-linux-gnueabi-
		elif [ "$KERNEL_COMPILER" == "3" ]
			then
				PATH="/root/aosp-clang/bin/:/root/gcc-4.9/arm64/bin/:/root/gcc-4.9/arm/bin/:${PATH}" \
				make -C ${KERNEL} -j$(nproc --all) -> ${KERNEL_TEMP}/compile.log O=out \
								CC=clang \
                                                                CLANG_TRIPLE=aarch64-linux-gnu- \
								CROSS_COMPILE=${CROSS_COMPILE} \
								CROSS_COMPILE_ARM32=${CROSS_COMPILE_ARM32}
		elif [ "$KERNEL_COMPILER" == "4" ]
			then
				PATH="/root/clang/bin/:${PATH}" \
				make -C ${KERNEL} -j$(nproc --all) -> ${KERNEL_TEMP}/compile.log O=out \
								CC=clang \
								CLANG_TRIPLE=aarch64-linux-gnu- \
								CROSS_COMPILE=aarch64-linux-gnu- \
								CROSS_COMPILE_ARM32=arm-linux-gnueabi-
		fi
		if ! [ -a $IMAGE ];
			then
                		echo "kernel not found"
                		END=$(date +"%s")
                		DIFF=$(($END - $START))
				cd ${KERNEL}
                		bot_build_failed
				cd ..
				sendStick "${TELEGRAM_FAIL}"
				curl -F chat_id=${TELEGRAM_GROUP_ID} -F document="@${KERNEL_TEMP}/compile.log"  https://api.telegram.org/bot${TELEGRAM_BOT_ID}/sendDocument
                		exit 1
        	fi
        	END=$(date +"%s")
        	DIFF=$(($END - $START))
		cd ${KERNEL}
		bot_build_success
		cd ..
		sendStick "${TELEGRAM_SUCCESS}"
		cp ${IMAGE} AnyKernel3
		anykernel
		kernel_upload
	}
function anykernel() {
	cd AnyKernel3
	make -j8
	mv Clarity-Kernel-${KERNEL_CODE}-signed.zip  ${KERNEL_TEMP}/${KERNEL_NAME}-${KERNEL_SUFFIX}-${KERNEL_CODE}-${KERNEL_REV}-${KERNEL_TAG}-${KERNEL_DATE}.zip
}
function kernel_upload(){
	cd ${KERNEL}
	bot_complete_compile
			curl -F chat_id=${TELEGRAM_GROUP_ID} -F document="@${KERNEL_TEMP}/compile.log"  https://api.telegram.org/bot${TELEGRAM_BOT_ID}/sendDocument
curl -F chat_id=${TELEGRAM_GROUP_ID} -F document="@${KERNEL_TEMP}/${KERNEL_NAME}-${KERNEL_SUFFIX}-${KERNEL_CODE}-${KERNEL_REV}-${KERNEL_TAG}-${KERNEL_DATE}.zip"  https://api.telegram.org/bot${TELEGRAM_BOT_ID}/sendDocument
	
}
compile
