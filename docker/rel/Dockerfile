# Copyright Takeshi Yonezu. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

FROM ubuntu:16.04

ARG GITLOG="${GITLOG}"
ARG BUILD_DATE="${BUILD_DATE}"
ARG BUILD_NO="${BUILD_NO}"
ARG BUILD_HOST="${BUILD_HOST}"

LABEL GITLOG="${GITLOG}"
LABEL BUILD_DATE="${BUILD_DATE}"
LABEL BUILD_NO="${BUILD_NO}"
LABEL BUILD_HOST="${BUILD_HOST}"

ENV IROHA_HOME=/opt/iroha
ENV LD_LIBRARY_PATH=${IROHA_HOME}/lib

COPY iroha ${IROHA_HOME}

RUN apt update && \
    apt upgrade -y && \
    useradd -ms /bin/bash iroha && \
    chown -R iroha:iroha ${IROHA_HOME} && \
    echo "PATH=\$PATH:/opt/iroha/bin" >>/home/iroha/.bashrc

USER iroha

WORKDIR ${IROHA_HOME}

CMD ${IROHA_HOME}/bin/irohad --config config/iroha.conf --genesis_block config/genesis.block --keypair_name config/node0
