#!/bin/bash
#
# Copyright (c) 2019 Takeshi Yonezu
# All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

if [[ $# -eq 1 && ("$1" = "down" || "$1" = "restart")]]; then
  cd example/multi-node

  echo "$ docker-compose -f docker-compose.yml $1"
  docker-compose -f docker-compose.yml $1

  exit 0
fi

if [ $# -lt 1 ]; then
  echo "Usage: iroha-1st.sh <ip-address> [ <node-name> ]"
  exit 1
fi

cd example/multi-node

cat genesis.block.in | sed "s/IP_ADDRESS/$1/" >genesis.block.1st

if [ $# -ge 2 ]; then
  IROHA_NODEKEY=$2
else
  IROHA_NODEKEY=node0
fi

cat docker-compose.yml.in |
  sed "s/IROHA_NODEKEY=.*/IROHA_NODEKEY=${IROHA_NODEKEY}/" >docker-compose.yml

echo "$ docker-compose -f docker-compose.yml up -d"
docker-compose -f docker-compose.yml up -d

exit 0
