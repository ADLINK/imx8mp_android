# Android 15 for ADLINK LEC-iMX8MP

## Preparation

### Installing Dependency Packages
```
$ sudo apt-get install uuid uuid-dev zlib1g-dev liblz-dev liblzo2-2 liblzo2-dev lzop git curl u-boot-tools mtd-utils android-sdk-libsparse-utils
$ sudo apt-get install device-tree-compiler gdisk m4 bison flex make libssl-dev gcc-multilib libgnutls28-dev swig liblz4-tool libdw-dev
$ sudo apt-get install dwarves bc cpio tar lz4 rsync ninja-build clang libelf-dev build-essential libncurses5
```

### Setup GIT
```
$ git config --global user.name "First Last"
$ git config --global user.email "first.last@company.com"
```

### Setup GCC Compiler
Download GCC from [here](https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu/12.3.rel1/binrel/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz) and copy into ${HOME} directory
```

$ sudo tar -xvJf ${HOME}/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz -C /opt
$ export AARCH64_GCC_CROSS_COMPILE=/opt/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
```

### Setup CLANG Compiler

```
$ sudo git clone -b main-kernel-build-2024 --single-branch --depth 1 https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 /opt/prebuilt-android-clang
$ cd /opt/prebuilt-android-clang
$ sudo git fetch origin 7061673283909f372f4938e45149d23bd10cbd40
$ sudo git checkout 7061673283909f372f4938e45149d23bd10cbd40
$ export CLANG_PATH=/opt/prebuilt-android-clang
$ export LIBCLANG_PATH=/opt/prebuilt-android-clang/clang-r510928/lib
```
### Setup Kernel Build Tools

```
$ sudo git clone -b main-kernel-build-2024 --single-branch --depth 1 https://android.googlesource.com/kernel/prebuilts/build-tools /opt/prebuilt-android-kernel-build-tools
$ cd /opt/prebuilt-android-kernel-build-tools
$ sudo git fetch origin b46264b70e3cdf70d08c9ae2df6ea3002b242ebc
$ sudo git checkout b46264b70e3cdf70d08c9ae2df6ea3002b242ebc
$ export PATH=/opt/prebuilt-android-kernel-build-tools/linux-x86/bin:$PATH
```
### Setup RUST

```
$ sudo git clone -b main-kernel-build-2024 --single-branch --depth 1 https://android.googlesource.com/platform/prebuilts/rust /opt/prebuilt-android-rust
$ cd /opt/prebuilt-android-rust
$ sudo git fetch origin 442511af884f074018466f85b4daadd4b0ac0050
$ sudo git checkout 442511af884f074018466f85b4daadd4b0ac0050
$ export PATH=/opt/prebuilt-android-rust/linux-x86/1.73.0b/bin:$PATH
```
### Setup CLANG Tools

```
$ sudo git clone -b main-kernel-build-2024 --single-branch --depth 1 https://android.googlesource.com/platform/prebuilts/clang-tools /opt/prebuilt-android-clang-tools
$ cd /opt/prebuilt-android-clang-tools
$ sudo git fetch origin 1634c6a556d1f2c24897bf74156c6449486e8941
$ sudo git checkout 1634c6a556d1f2c24897bf74156c6449486e8941
$ export PATH=/opt/prebuilt-android-clang-tools/linux-x86/bin:$PATH
```
## Download Android source from NXP and patches from Adlink GitHub
Download "imx-android-15.0.0_1.0.0.tar.gz" from NXP site available [here](https://www.nxp.com/webapp/Download?colCode=15.0.0_1.0.0_ANDROID_SOURCE&appType=license) and copy into ${HOME} directory
```
$ mkdir ${HOME}/bin
$ curl https://storage.googleapis.com/git-repo-downloads/repo > ${HOME}/bin/repo
$ chmod a+x ${HOME}/bin/repo
$ export PATH=${PATH}:${HOME}/bin
$ cd ${HOME}
$ git clone https://github.com/ADLINK/imx8mp_android.git -b Android-15
$ tar xzvf imx-android-15.0.0_1.0.0.tar.gz
$ source ${HOME}/imx-android-15.0.0_1.0.0/imx_android_setup.sh
```


## Apply LEC-iMX8MP patches
### 1. Android Device
```
$ cd ${HOME}/android_build/device/nxp
$ git am ${HOME}/imx8mp_android/patches/imx-android-15.0.0_1.0.0/android_build/lec-imx8mp/device/nxp/0001-lec-imx8mp-Add-device-support.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-15.0.0_1.0.0/android_build/lec-imx8mp/device/nxp/0002-SDCard_automount_tlv320_support.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-15.0.0_1.0.0/android_build/lec-imx8mp/device/nxp/0003-Added-tlv320_config.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-15.0.0_1.0.0/android_build/lec-imx8mp/device/nxp/0004-lec-imx8mp-Device-changes-unified-codec-support.patch
```

### 2. Kernel
```
$ cd ${HOME}/android_build/vendor/nxp-opensource/kernel_imx
$ git am ${HOME}/imx8mp_android/patches/imx-android-15.0.0_1.0.0/android_build/lec-imx8mp/vendor/nxp-opensource/kernel_imx/0001-lec-imx8mp-Add-initial-board-support.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-15.0.0_1.0.0/android_build/lec-imx8mp/vendor/nxp-opensource/kernel_imx/0002-tlv320_codec_support.patch
```

### 3. U-boot
```
$ cd ${HOME}/android_build/vendor/nxp-opensource/uboot-imx
$ git am ${HOME}/imx8mp_android/patches/imx-android-15.0.0_1.0.0/android_build/lec-imx8mp/vendor/nxp-opensource/uboot-imx/0001-lec-imx8mp-Add-initial-board-support.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-15.0.0_1.0.0/android_build/lec-imx8mp/vendor/nxp-opensource/uboot-imx/0002-lec-imx8mp-uboot-detect-i2c-tlv320.patch
```

### 4. imx-mkimage
```
$ cd ${HOME}/android_build/vendor/nxp-opensource/imx-mkimage
$ git am ${HOME}/imx8mp_android/patches/imx-android-15.0.0_1.0.0/android_build/lec-imx8mp/vendor/nxp-opensource/imx-mkimage/0001-lec-imx8mp-add-support-to-compile-lec-dtb.patch
```

### 5. Libbt
```
$ cd ${HOME}/android_build/hardware/nxp/libbt
$ git am ${HOME}/imx8mp_android/patches/imx-android-15.0.0_1.0.0/android_build/lec-imx8mp/hardware/nxp/libbt/0001-lec-imx8mp-Add-bt-uart-support.patch
```

### 6. External Libraries
```
$ cd ${HOME}/android_build/external
$ git apply ${HOME}/imx8mp_android/patches/imx-android-15.0.0_1.0.0/android_build/lec-imx8mp/external/0001-can-spi-pwm-utils.patch
```

Compile Android 15 BSP
------------------------------
```
$ cd ${HOME}/android_build
$ source build/envsetup.sh
$ lunch lec_imx8mp-nxp_stable-userdebug
$ ./imx-make.sh -j4 2>&1 | tee build-log.txt
```
