#!/bin/bash
set -e

# Go to script directory
pushd "$(dirname "$0")"

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
readonly DEFCONFIG=qemu_minimal_defconfig

rm -rf ./build
rm -rf ./dist
mkdir ./build
mkdir ./dist

make O=./build "${DEFCONFIG}"
make O=./build "-j$(nproc)" Image.gz modules dtbs

cp ./build/arch/${ARCH}/boot/Image.gz ./dist

popd
