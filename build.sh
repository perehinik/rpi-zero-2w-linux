#!/bin/bash
set -e

show_help() {
    echo "Usage: $(basename "$0") [-d] [-h]"
    echo
    echo "Options:"
    echo "  -d               Run inside Docker."
    echo "  -h               Show this help message."
}

USE_DOCKER=0
DOCKER_IMAGE=perehiniak/linux-build-tools:1.0.0

while getopts "dh" opt; do
    case "$opt" in
        d) USE_DOCKER=1 ;;
        h)
            show_help
            exit 0
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            show_help
            exit 1
            ;;
        \?)
            show_help
            exit 1
            ;;
    esac
done

if [ "$USE_DOCKER" = "1" ] && [ -z "${INSIDE_DOCKER:-}" ]; then
    exec docker run -it \
        --rm \
        -v ./:/home/builder \
        -e INSIDE_DOCKER=1 \
        ${USER_SCRIPT_OPTION} \
        -w /home/builder \
        -u builder \
        --entrypoint "$0" \
        ${DOCKER_IMAGE} \
        "$@"
fi

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
