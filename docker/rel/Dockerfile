# Copyright (c) 2017-2021 Takeshi Yonezu
# All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

FROM ubuntu:20.04 as builder
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y \
 && apt install -y --no-install-recommends \
      file build-essential ninja-build git ca-certificates tar curl unzip \
      cmake pkg-config zip \
 && curl https://sh.rustup.rs -sSf | sh -s -- -y

ENV PATH ${HOME}/go/bin:/usr/local/go/bin:$PATH
ENV GOPATH ${HOME}/go

RUN curl -fsSL https://golang.org/dl/go1.15.15.linux-amd64.tar.gz | tar -C /usr/local -xzf - \
 && (cd ${HOME}; mkdir go/src; cd go/src; \
      go get -u google.golang.org/protobuf/cmd/protoc-gen-go; \
      go install google.golang.org/protobuf/cmd/protoc-gen-go)

ENV PATH /root/.cargo/bin:$PATH

   RUN apt install -y libssl-dev \
    && cargo install cargo-edit \
    && git clone https://github.com/sagiegurari/cargo-make.git /root \
    && cd /root/cargo-make; cargo install --force cargo-make

RUN git clone https://github.com/hyperledger/iroha.git -b 1.3.0-rc.1 \
 && iroha/vcpkg/build_iroha_deps.sh \
 && /vcpkg-build/vcpkg integrate install

WORKDIR /iroha/build

## RUN cmake -B. -S..  -DCMAKE_BUILD_TYPE=Release -DTESTING=OFF -DCMAKE_TOOLCHAIN_FILE=/vcpkg-build/scripts/buildsystems/vcpkg.cmake \
## RUN cmake -B. -S..  -DCMAKE_BUILD_TYPE=Release -DTESTING=OFF -DUSE_LIBURSA=ON -DUSE_BURROW=ON -DCMAKE_TOOLCHAIN_FILE=/vcpkg-build/scripts/buildsystems/vcpkg.cmake \
RUN cmake -B. -S..  -DCMAKE_BUILD_TYPE=Release -DTESTING=OFF -DUSE_BURROW=ON -DCMAKE_TOOLCHAIN_FILE=/vcpkg-build/scripts/buildsystems/vcpkg.cmake \
 && cmake --build . -- -j$(nproc)

FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

ARG GITLOG="${GITLOG}"
ARG BUILD_DATE="${BUILD_DATE}"
ARG BUILD_NO="${BUILD_NO}"
ARG BUILD_HOST="${BUILD_HOST}"

LABEL GITLOG="${GITLOG}"
LABEL BUILD_DATE="${BUILD_DATE}"
LABEL BUILD_NO="${BUILD_NO}"
LABEL BUILD_HOST="${BUILD_HOST}"

ENV IROHA_HOME=/opt/iroha
ENV PATH PATH=${PATH}:${IROHA_HOME}/bin

RUN apt update && apt upgrade -y \
 && apt install -y moreutils jq python3 python3-pip \
 && pip install iroha \
 && apt purge -y $(apt -s purge python3-pip | grep '^ ' | tr -d '*') \
 && apt clean -y \
 && rm -fr /var/lib/apt/lists/*

COPY --from=builder /iroha/build/bin/irohad /usr/bin/irohad
COPY --from=builder /iroha/build/bin/iroha-cli /usr/bin/iroha-cli
COPY --from=builder /iroha/example/ /opt/iroha/config/
COPY --from=builder /iroha/docker/release/wait-for-it.sh /
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh /wait-for-it.sh

WORKDIR /opt/iroha/config
ENTRYPOINT ["/entrypoint.sh"]
CMD ["irohad"]
