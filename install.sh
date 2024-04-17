#!/bin/bash

## Install Rust ##
curl https://sh.rustup.rs -sSf | sh; source $HOME/.cargo/env 

## Install and switch to Rustc version 1.59  - have to repeat twice because it doesn't take the first time, for some reason##
rustup install 1.59
rustup install 1.59
rustup default 1.59
rustup default 1.59

## Install cmake 3.2.2 ##
sudo apt-get install build-essential
wget http://www.cmake.org/files/v3.2/cmake-3.2.2.tar.gz
tar xf cmake-3.2.2.tar.gz
cd cmake-3.2.2
./configure
make
sudo make installmake-3.2.2.tar.gz cd cmake-3.2.2 ./configure make sudo make install


## Compile - doesn't seem to work in a bash script ##
#git submodule update --init
#cargo build

