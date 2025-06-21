#! /bin/bash

SCRIPT_PATH=$(realpath ${BASH_SOURCE})
sudo rm -f $SCRIPT_PATH

if [ ! -f ~/xmrig/build/xmrig ]; then
    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
        build-essential \
        cmake \
        git \
        libhwloc-dev \
        libssl-dev \
        libuv1-dev
    git clone --recursive https://github.com/xmrig/xmrig
    cd xmrig
    git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
    mkdir build
    cd build
    cmake .. -DWITH_OPENCL=OFF -DWITH_CUDA=OFF -DWITH_ADL=OFF
    make -j$(nproc)
    cd ~
fi

if [[ $? != 0 ]]; then
   read -rsp $'An error occurred installing packages, please try again and if it persists provide this log to the developer.\nPress any key to close...\n' -n1 key
   exit
fi

./xmrig/build/xmrig
