ADLINK LEC-IMX8MP 2GB Module with iPI SMARC plus Android 11 BSP
==================================================================

Preparation
===========

Installing Dependency Packagages
--------------------------------

- sudo apt-get install uuid uuid-dev zlib1g-dev liblz-dev liblzo2-2 liblzo2-dev lzop 
- sudo apt-get install git curl u-boot-tools mtd-utils android-sdk-libsparse-utils android-sdk-ext4-utils 
- sudo apt-get install device-tree-compiler gdisk m4 zlib1g-dev bison flex make libssl-dev gcc-multilib

Git Setup
---------

- git config --global user.name "First Last"
- git config --global user.email "first.last@company.com"

To setup GCC Compiler
---------------------

- sudo tar -xvJf arm-gnu-toolchain-13.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz -C /opt
- export AARCH64_GCC_CROSS_COMPILE=/opt/arm-gnu-toolchain-13.2.Rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-


To setup CLANG compiler
-----------------------

- sudo git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86  /opt/prebuilt-android-clang
- cd /opt/prebuilt-android-clang
- sudo git checkout d20e409261d6ad80a0c29ac2055bf5c3bb996ef4
- export CLANG_PATH=/opt/prebuilt-android-clang

To download the source from NXP
-------------------------------

- $ mkdir ~/bin
- $ curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
- $ chmod a+x ~/bin/repo
- $ export PATH=${PATH}:~/bin
- $ tar -zxvf imx-android-13.0.0_1.2.0.tar.gz
- $ source imx-android-13.0.0_2.2.0/imx_android_setup.sh 

Now Android 13 source will be downloaded into android_build directory



To Compile the Android 13 BSP
------------------------------
- $ cd android_build
- $ source build/envsetup.sh
- $ lunch sp2_imx8mp-userdebug
- $ ./imx-make.sh -j4 2>&1 | tee build-log.txt

