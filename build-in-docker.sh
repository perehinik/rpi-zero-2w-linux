#!/bin/bash
set -e

DOCKER_IMAGE=perehiniak/linux-build-tools:1.0.0

docker run -it \
        --rm \
        -v ./:/home/builder \
        ${USER_SCRIPT_OPTION} \
        -w /home/builder \
        -u builder \
        --entrypoint ./build.sh \
        ${DOCKER_IMAGE}
