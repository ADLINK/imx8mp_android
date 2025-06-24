#!/bin/sh -e

CWD=$(pwd)
PATCHROOTDIR=$(dirname $0)
MACHINE=${1:-sp2_imx8mp}
RELEASE_FILES=$(cat ${CWD}/${PATCHROOTDIR}/filelist.txt | xargs)

usage () {
        echo "Syntax:"
        echo "  gen_release.sh <machine>"
        echo "  please run the gen_release.sh script from android's build directory"
}
if [ -d ${CWD}/out/target/product/${MACHINE} ]; then
	cd ${CWD}/out/target/product/${MACHINE}
	tar zcvf ../../../../android-13-${MACHINE}.tgz ${RELEASE_FILES} Android/
	cd -
else
	usage
fi
