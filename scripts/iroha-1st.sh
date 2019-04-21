#!/bin/bash
#
# Copyright (c) 2019 Takeshi Yonezu
# All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

if [ $# -lt 2 ]; then
  echo "Usage: iroha-1st.sh <ip-address> <node-name>"
  exit 1
fi

case $(uname -m) in
  x86_64)  ARCH=hyperledger;;
  armv7l)  ARCH=arm32v7;;
  aarch64) ARCH=arm64v8;;
  *) echo "$(uname -s)/$(uname -m) does'nt support." exit 1;;
esac

IMAGE=$(cat .env | grep IROHA_IMG | sed 's/IROHA_IMG=//')

cd example/multi-node

cat genesis.block.in | sed "s/IP_ADDRESS/$1/" >genesis.block.1st

cat docker-compose.yml.in |
  sed -e "s|IMAGE: .*|image: ${ARCH}/${IMAGE}|" \
      -e "s/IROHA_NODEKEY=.*/IROHA_NODEKEY=$2/" >docker-compose.yml

echo "$ docker-compose -f docker-compose.yml up -d"
docker-compose -f docker-compose.yml up -d

exit 0
