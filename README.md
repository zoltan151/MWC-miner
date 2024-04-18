
# MWC Miner

A standalone mining implementation intended for mining MWC against a running MWC node.

## Supported Platforms

At present, only mining plugins for linux-x86_64 and MacOS exist. This will likely change over time as the community creates more solvers for different platforms.

## Requirements

- rust 1.59 (included in install script)
  
- cmake 3.2+ (included in install script) (for [Cuckoo mining plugins]((https://github.com/mimblewimble/cuckoo-miner))) -

- ncurses and libs (included in install script)
- zlib libs (included in install script)
- linux-headers (included in install script)

And a [running MWC node](https://github.com/mimblewimble/MWC/blob/master/doc/build.md) to mine into!

## Build steps

```sh
## Go to root directory ##
cd /

## Apt update ##
sudo apt-get -y update

## Install the linux headers ##
sudo apt-get -y install linux-headers-$(uname -r)

## Install ncurses and libs ##
sudo apt-get -y install libncurses5-dev libncursesw5-dev

## Install zlib libs ##
sudo apt-get -y install zlib1g-dev

## Apt update and install OpenCL libraries ##
sudo apt-get -y install ocl-icd-opencl-dev

## Ensure $PATH env variable is correctly set ##
sudo export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"

## Delete existing MWC-miner directory, if it exists ##
cd /
sudo rm -rf MWC-miner

## Install Rust ##
cd /
sudo curl https://sh.rustup.rs -sSf | sudo sh; source $HOME/.cargo/env 

## Install and switch to Rustc version 1.59  - have to repeat twice because it doesn't take the first time, for some reason. Will have to look into that later. ##
rustup install 1.59
rustup default 1.59
rustup default 1.59

## Install cmake 3.2.2 ##
cd /
sudo apt-get -y remove cmake
sudo apt-get -y install build-essential
sudo wget http://www.cmake.org/files/v3.2/cmake-3.2.2.tar.gz
sudo tar -zxvf cmake-3.2.2.tar.gz
cd cmake-3.2.2
./configure
make
sudo make install

## Install GNU / GCC ##
cd /
sudo apt-get -y update
sudo apt-get -y install -y build-essential
sudo apt-get -y install g++
wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-8/gcc-8_8.4.0-3ubuntu2_amd64.deb
wget http://mirrors.edge.kernel.org/ubuntu/pool/universe/g/gcc-8/gcc-8-base_8.4.0-3ubuntu2_amd64.deb
wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-8/libgcc-8-dev_8.4.0-3ubuntu2_amd64.deb
wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-8/cpp-8_8.4.0-3ubuntu2_amd64.deb
wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-8/libmpx2_8.4.0-3ubuntu2_amd64.deb
wget http://mirrors.kernel.org/ubuntu/pool/main/i/isl/libisl22_0.22.1-1_amd64.deb
sudo apt-get -y install ./libisl22_0.22.1-1_amd64.deb ./libmpx2_8.4.0-3ubuntu2_amd64.deb ./cpp-8_8.4.0-3ubuntu2_amd64.deb ./libgcc-8-dev_8.4.0-3ubuntu2_amd64.deb ./gcc-8-base_8.4.0-3ubuntu2_amd64.deb ./gcc-8_8.4.0-3ubuntu2_amd64.deb
wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-8/libstdc++-8-dev_8.4.0-3ubuntu2_amd64.deb
wget http://mirrors.kernel.org/ubuntu/pool/universe/g/gcc-8/g++-8_8.4.0-3ubuntu2_amd64.deb
sudo apt-get -y install ./libstdc++-8-dev_8.4.0-3ubuntu2_amd64.deb ./g++-8_8.4.0-3ubuntu2_amd64.deb
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 8

## Install CUDA toolkit and Nvidia drivers ##
cd /
#sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
#sudo bash -c 'echo "deb [allow-insecure=yes] http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list'
#sudo bash -c 'echo "deb [allow-insecure=yes] http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda_learn.list'
#sudo apt-get -y update
#sudo apt-get -y install cuda-10-1
#sudo apt-get -y install libcudnn7
wget https://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda_10.2.89_440.33.01_linux.run
sudo sh cuda_10.2.89_440.33.01_linux.run
export PATH=/usr/local/cuda-10.2/bin:/usr/local/cuda-10.2/NsightCompute-2019.1${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib64\${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
# sudo apt-get -y install nvidia-driver-535
# sudo add-apt-repository ppa:graphics-drivers
sudo apt-get -y install ubuntu-drivers-common
sudo ubuntu-drivers devices

## Install OpenSSL ##
cd /
sudo apt-get -y remove openssl
wget https://www.openssl.org/source/openssl-1.1.1w.tar.gz
tar xvzf openssl-1.1.1w.tar.gz
cd openssl-1.1.1w
./config
make
sudo make install
sudo apt-get -y install libssl-dev

## Clone and Build ##
cd /
git clone https://github.com/zoltan151/MWC-miner.git
cd MWC-miner
git submodule update --init
cargo build --features opencl 
./install_ocl_plugins.sh
cp MWC-miner.toml target/debug/MWC-miner.toml
cd target/debug
```

### Building the Cuckoo-Miner plugins

MWC-miner automatically builds x86_64 CPU plugins. Cuda plugins are also provided, but are
not enabled by default. To enable them, modify `Cargo.toml` as follows:

```
change:
cuckoo_miner = { path = "./cuckoo-miner" }
to:
cuckoo_miner = { path = "./cuckoo-miner", features = ["build-cuda-plugins"]}
```

The Cuda toolkit 9+ must be installed on your system (check with `nvcc --version`)

### Building the OpenCL plugins
OpenCL plugins are not enabled by default. Run `install_ocl_plugins.sh` script to build and install them.

```
./install_ocl_plugins.sh
```
You must install OpenCL libraries for your operating system before.
If you just need to compile them (for development or testing purposes) build MWC-miner the following way:

```
cargo build --features opencl
```

### Build errors

See [Troubleshooting](https://github.com/mimblewimble/docs/wiki/Troubleshooting)

## What was built?

A successful build gets you:

 - `target/debug/MWC-miner` - the main MWC-miner binary
 - `target/debug/plugins/*` - mining plugins

Make sure you always run MWC-miner within a directory that contains a
`MWC-miner.toml` configuration file.

While testing, put the MWC-miner binary on your path like this:

```
export PATH=/path/to/MWC-miner/dir/target/debug:$PATH
```

You can then run `MWC-miner` directly.

# Configuration

MWC-miner can be further configured via the `MWC-miner.toml` file.
This file contains contains inline documentation on all configuration
options, and should be the first point of reference.

You should always ensure that this file exists in the directory from which you're
running MWC-miner.

# Using MWC-miner

There is a [MWC forum post](https://www.MWC-forum.org/t/how-to-mine-cuckoo-30-in-MWC-help-us-test-and-collect-stats/152) with further detail on how to configure MWC-miner and mine MWC's testnet.
