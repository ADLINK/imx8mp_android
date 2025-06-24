ADLINK SP2IMX8MP Android 13 BSP
==================================================================

```
This document outlines the procedures for Build and Flash Android BSP for SP2IX8MP

1.Prerequisite
2.Host Machine Setup
3.Download the source from NXP
4.Build Instructions
5.Flash Procedure for Android 13 SP2-IMX8MP
```

Prerequisite
===========

### Host machine :

- Machine: x86

- Host OS : Ubuntu 20.04 or 22.04

- RAM: Minimum of 16 GB RAM.

- Storage : 300GB
  (Recommended storage medium SSD ,Encountered unexpected build error in HDD)

Host Machine Setup
==================================================================
Installing Dependency Packages
------------------------------------

Use the following commands to install the dependency packages.

```Shell
$ sudo apt-get install uuid uuid-dev zlib1g-dev liblz-dev liblzo2-2 liblzo2-dev lzop git curl u-boot-tools mtd-utils android-sdk-libsparse-utils
$ sudo apt-get install device-tree-compiler gdisk m4 bison flex make libssl-dev gcc-multilib libgnutls28-dev swig liblz4-tool libdw-dev
$ sudo apt-get install dwarves bc cpio tar lz4 rsync ninja-build clang libelf-dev build-essential libncurses5 mtools

```

Setup GIT
---------
Use the following commands for git configuration.

```Shell
git config --global user.name "First Last"
git config --global user.email "first.last@company.com
```


## Setup GCC Compiler

Download GCC from [here](https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz?rev=22c39fc25e5541818967b4ff5a09ef3e&hash=B9FEDC2947EB21151985C2DC534ECCEC) and copy into ${HOME} directory

```Shell
sudo tar -xvJf ${HOME}/arm-gnu-toolchain-13.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz -C /opt

export AARCH64_GCC_CROSS_COMPILE=/opt/arm-gnu-toolchain-13.2.Rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
```

## Setup CLANG Compiler

```Shell
sudo git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86  /opt/prebuilt-android-clang

cd /opt/prebuilt-android-clang

sudo git checkout d20e409261d6ad80a0c29ac2055bf5c3bb996ef4

export CLANG_PATH=/opt/prebuilt-android-clang
```

## Download Android source from NXP and patches from Adlink GitHub

- Download the "imx-android-13.0.0_2.2.0.tar.gz" from NXP site [Click here](https://www.nxp.com/webapp/sps/download/license.jsp?colCode=13.0.0_2.2.0_ANDROID_SOURCE&appType=file1&DOWNLOAD_ID=null) and copy into ${HOME} directory

  ```shell
  $ mkdir ${HOME}/bin
  $ curl https://storage.googleapis.com/git-repo-downloads/repo > ${HOME}/bin/repo
  $ chmod a+x ${HOME}/bin/repo
  $ export PATH=${PATH}:${HOME}/bin
  $ cd ${HOME}
  $ git clone --branch SP2IMX8MP-93-P1500 https://github.com/ADLINK/imx8mp_android.git
  $ tar -zxvf imx-android-13.0.0_2.2.0.tar.gz
  $ source ${HOME}/imx-android-13.0.0_2.2.0/imx_android_setup.sh

### Apply SP2-IMX8MP patches

### 1. Android Device

```Shell
cd ${HOME}/android_build/device/nxp/

git am ${HOME}/imx8mp_android/patches/imx-android-13.0.0_2.2.0/android_build/device/nxp/0001-sp2-imx8mp-device-changes.patch
```

### 2. Kernel

```Shell
cd ${HOME}/android_build/vendor/nxp-opensource/kernel_imx/

git am ${HOME}/imx8mp_android/patches/imx-android-13.0.0_2.2.0/android_build/vendor/nxp-opensource/kernel_imx/0001-sp2-imx8mp-Add-Kernel-support.patch
```

### 3. U-boot

```Shell
cd ${HOME}/android_build/vendor/nxp-opensource/uboot-imx/

git am ${HOME}/imx8mp_android/patches/imx-android-13.0.0_2.2.0/android_build/vendor/nxp-opensource/uboot-imx/0001-sp2-imx8mp-Add-initial-board-support.patch
```

### 4. Build

```Shell
cd ${HOME}/android_build/build/make/

git am ${HOME}/imx8mp_android/patches/imx-android-13.0.0_2.2.0/android_build/build/make/0001-sp2-imx8mp-Build-Id-camera-app-SM.patch
```

### 5. External Libraries

```shell
cd ${HOME}/android_build/external/

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_2.2.0/android_build/external/0001-external_can_spi_beep_eltt2_utils.patch
```

### 6. imx-mkimage

```shell
cd ${HOME}/android_build/vendor/nxp-opensource/imx-mkimage/

git am ${HOME}/imx8mp_android/patches/imx-android-13.0.0_2.2.0/android_build/vendor/nxp-opensource/imx-mkimage/0001-sp2-imx8mp-add-support-to-compile-sp2-dtb.patch
```

### 7. Framework

```Shell
cd ${HOME}/android_build/frameworks/av

git am ${HOME}/imx8mp_android/patches/imx-android-13.0.0_2.2.0/android_build/frameworks/av/0001-Adding-audio-gain-HDMI.patch

cd ${HOME}/android_build/frameworks/base

git am ${HOME}/imx8mp_android/patches/imx-android-13.0.0_2.2.0/android_build/frameworks/base/0001-sp2-imx8mp-Remove-battery-icon.patch
```

## To Compile the Android 13 BSP

- After applying all patches, build the source

```shell
  cd ${HOME}/android_build
  source build/envsetup.sh
  lunch sp2_imx8mp-userdebug
  ./imx-make.sh -j3 2>&1 | tee build-log.txt
```

Output Image Path
--------------------------------------

Image will be generate in the  path :  ${HOME}/android_build/out/target/product/sp2_imx8mp/

Refer Readme.md for Flash Procedure.
