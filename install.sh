#!/bin/bash


## Install cmake 3.2.2 ##
sudo apt-get install build-essential
wget http://www.cmake.org/files/v3.2/cmake-3.2.2.tar.gz
tar xf cmake-3.2.2.tar.gz
cd cmake-3.2.2
./configure
make
sudo make install


## Compile - doesn't seem to work in a bash script ##
#git submodule update --init
#cargo build

