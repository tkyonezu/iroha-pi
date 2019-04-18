#!/bin/bash
#
# Copyright (c) 2019 Takeshi Yonezu
# All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

if [ $# -lt 1 ]; then
  echo "Usage: iroha-1st.sh <ip-address>"
  exit 1
fi

cd example/multi-node

cat genesis.block.in | sed "s/IP_ADDRESS/$1/" >genesis.block1st

case $(uname -m) in
  x86_64)  ARCH=hyperledger;;
  armv7l)  ARCH=arm32v7;;
  aarch74) ARCH=arm64v8;;
  *) echo "$(uname -s)/$(uname 0m) does'nt support." exit 1;;
esac

cat docker-compose.yml.in | sed "s/ARCH/${ARCH}/" >docker-compose.yml

pwd
echo "$ docker-compose -f docker-compose.yml up -d"

docker-compose -f docker-compose.yml up -d

exit 0
