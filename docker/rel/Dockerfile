# Copyright (c) 2017-2021 Takeshi Yonezu
# All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

FROM ubuntu:20.04 as builder
ARG DEBIAN_FRONTEND=noninteractive

ENV IROHA_VERSION=1.3.0-rc.1

ENV GO_VERSION=1.15.15
ENV GO_OS=linux
ENV GO_ARCH=amd64

ENV HOME=/root

ENV BUILD_HOME=/iroha
ENV IROHA_VCPKG=${BUILD_HOME}/vcpkg
ENV VCPKG_PATH=${BUILD_HOME}/vcpkg-build

RUN apt update && apt upgrade -y \
 && apt install -y --no-install-recommends \
      file build-essential ninja-build git ca-certificates tar curl unzip \
      cmake pkg-config zip

ENV PATH=${HOME}/go/bin:/usr/local/go/bin:${PATH}
ENV GOPATH=${HOME}/go

RUN curl -fsSL https://golang.org/dl/go${GO_VERSION}.${GO_OS}-${GO_ARCH}.tar.gz | tar -C /usr/local -xzf - \
 && (cd ${HOME}; mkdir -p go/src; cd go/src; \
      go get -u google.golang.org/protobuf/cmd/protoc-gen-go; \
      go install google.golang.org/protobuf/cmd/protoc-gen-go)

ENV PATH=${HOME}/.cargo/bin:${PATH}

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y \
 && apt install -y libssl-dev \
 && cargo install cargo-edit \
 && git clone https://github.com/sagiegurari/cargo-make.git ${HOME} \
 && cd ${HOME}/cargo-make; cargo install --force cargo-make

RUN git clone https://github.com/hyperledger/iroha.git -b ${IROHA_VERSION} \
 && sed -i 's/^ *arm\*/&|aarch64/' ${IROHA_VCPKG}/build_iroha_deps.sh \
 && ${IROHA_VCPKG}/build_iroha_deps.sh ${VCPKG_PATH} \
 && ${VCPKG_PATH}/vcpkg integrate install

WORKDIR ${BUILD_HOME}/build

RUN cmake -B. -S.. -DCMAKE_BUILD_TYPE=Release -DTESTING=OFF \
      -DUSE_LIBURSA=ON -DUSE_BURROW=ON \
      -DCMAKE_TOOLCHAIN_FILE=${VCPKG_PATH}/scripts/buildsystems/vcpkg.cmake \
 && cmake --build . -- -j$(nproc) \
 && strip ${BUILD_HOME}/build/bin/irohad ${BUILD_HOME}/build/bin/iroha-cli ${BUILD_HOME}/build/irohad/migration-tool/migration-tool ${BUILD_HOME}/build/irohad/migration-tool/migration-tool

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

ENV BUILD_HOME=/iroha
ENV IROHA_HOME=/opt/iroha

RUN apt update && apt upgrade -y \
## && apt install -y moreutils jq python3 python3-pip \
## && pip install iroha \
## && apt purge -y $(apt -s purge python3-pip | grep '^ ' | tr -d '*') \
 && apt clean -y \
 && rm -fr /var/lib/apt/lists/*

COPY --from=builder ${BUILD_HOME}/build/bin/irohad /usr/bin/irohad
COPY --from=builder ${BUILD_HOME}/build/bin/iroha-cli /usr/bin/iroha-cli
COPY --from=builder ${BUILD_HOME}/build/irohad/migration-tool/migration-tool /usr/bin/iroha-migration-tool
COPY --from=builder ${BUILD_HOME}/docker/release/wait-for-it.sh /
COPY entrypoint.sh /

RUN chmod +x /wait-for-it.sh /entrypoint.sh \
 && mkdir -p ${IROHA_HOME}/config

WORKDIR ${IROHA_HOME}/config

ENTRYPOINT ["/entrypoint.sh"]
CMD ["irohad"]
