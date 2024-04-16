[![Build Status](https://dev.azure.com/mimblewimble/MWC-miner/_apis/build/status/mimblewimble.MWC-miner?branchName=master)](https://dev.azure.com/mimblewimble/MWC-miner/_build/latest?definitionId=5&branchName=master)

# MWC Miner

A standalone mining implementation intended for mining MWC against a running MWC node.

## Supported Platforms

At present, only mining plugins for linux-x86_64 and MacOS exist. This will likely change over time as the community creates more solvers for different platforms.

## Requirements

- rust 1.59 (use [rustup]((https://www.rustup.rs/))- i.e. `curl https://sh.rustup.rs -sSf | sh; source $HOME/.cargo/env | rustup install 1.59 | rustup default 1.59`)
  
- cmake 3.2+ (for [Cuckoo mining plugins]((https://github.com/mimblewimble/cuckoo-miner))) -
  (run the following to install:
sudo apt-get install build-essential
wget http://www.cmake.org/files/v3.2/cmake-3.2.2.tar.gz
tar xf cmake-3.2.2.tar.gz
cd cmake-3.2.2
./configure
make
sudo make install
)

- ncurses and libs (ncurses, ncursesw5)
- zlib libs (zlib1g-dev or zlib-devel)
- linux-headers (reported needed on Alpine linux)

And a [running MWC node](https://github.com/mimblewimble/MWC/blob/master/doc/build.md) to mine into!

## Build steps

```sh
git clone https://github.com/zoltan151/MWC-miner.git
cd MWC-miner
git submodule update --init
cargo build
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
