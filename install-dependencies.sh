#!/bin/bash

apt-get update
apt-get install -y gcc-aarch64-linux-gnu \
	bc \
	flex \
	bison \
	make \
	libc6-dev \
	libssl-dev
