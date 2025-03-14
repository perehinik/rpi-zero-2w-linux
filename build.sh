#!/bin/bash

# Go to script directory
pushd "$(dirname "$0")"

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
readonly DEFCONFIG=rpi_zero_2w_defconfig

rm -rf ./build
rm -rf ./dist
mkdir ./build

make O=./build "${DEFCONFIG}"
make O=./build "-j$(nproc)" Image.gz modules dtbs

mkdir -p ./dist/boot/overlays
# This way modules will be installed into ./build/install/lib
make O=./build "-j$(nproc)" INSTALL_MOD_PATH=./install modules_install

cp ./build/arch/${ARCH}/boot/dts/broadcom/bcm2710-rpi-zero-2-w.dtb ./dist/boot/
cp ./build/arch/${ARCH}/boot/dts/overlays/*.dtb* ./dist/boot/overlays/
cp ./arch/${ARCH}/boot/dts/overlays/README ./dist/boot/overlays/
cp ./build/arch/${ARCH}/boot/Image.gz ./dist/boot/
mv ./build/install/* ./dist

popd
