# Multistage docker build, requires docker 17.05

# builder stage
FROM nvidia/cuda:10.0-devel as builder

RUN set -ex && \
    apt-get update && \
    apt-get --no-install-recommends --yes install \
        libncurses5-dev \
        libncursesw5-dev \
        cmake \
        git \
        curl \
        libssl-dev \
        pkg-config

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

RUN git clone https://github.com/zoltan151/MWC-miner && cd MWC-miner && git submodule update --init

RUN cd MWC-miner && sed -i '/^cuckoo_miner = {/s/^/#/' Cargo.toml && sed -i '/^#.*build-cuda-plugins"]/s/^#//' Cargo.toml

RUN cd MWC-miner && $HOME/.cargo/bin/cargo build --release

# runtime stage
FROM nvidia/cuda:10.0-base

RUN set -ex && \
    apt-get update && \
    apt-get --no-install-recommends --yes install \
    libncurses5 \
    libncursesw5

COPY --from=builder /MWC-miner/target/release/MWC-miner /MWC-miner/target/release/MWC-miner
COPY --from=builder /MWC-miner/target/release/plugins/* /MWC-miner/target/release/plugins/
COPY --from=builder /MWC-miner/MWC-miner.toml /MWC-miner/MWC-miner.toml

WORKDIR /MWC-miner

RUN sed -i -e 's/run_tui = true/run_tui = false/' MWC-miner.toml

RUN echo '#!/bin/bash\n\
if [ $# -eq 1 ]\n\
   then\n\
sed -i -e 's/127.0.0.1/\$1/g' MWC-miner.toml\n\
fi\n\
./target/release/MWC-miner' > run.sh

# If the grin server is not at 127.0.0.1 provide the ip or hostname to the container
# by command line (i.e. docker run --name miner1 --rm -i -t miner_image 1.2.3.4)

ENTRYPOINT ["sh", "run.sh"]
