#!/bin/bash

## Install Rustc version 1.59 ##
curl https://sh.rustup.rs -sSf | sh; source $HOME/.cargo/env | rustup install 1.59 | rustup default 1.59


## Install cmake 3.2.2 ##
sudo apt-get install build-essential
wget http://www.cmake.org/files/v3.2/cmake-3.2.2.tar.gz
tar xf cmake-3.2.2.tar.gz
cd cmake-3.2.2
./configure
make
sudo make installmake-3.2.2.tar.gz cd cmake-3.2.2 ./configure make sudo make install


## Clone GIT and compile ##
git submodule update --init
cargo build

