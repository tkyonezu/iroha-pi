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
  IROHA_IP=127.0.0.1
fi

if [ $# -ge 2 ]; then
  IROHA_NODEKEY=$2
else
  IROHA_NODEKEY=node0
fi

cd example/multi-node

if [ -f block_store/0000000000000001 ]; then
  echo ">> ERROR: genesis_block exist!!"
  exit 1
fi

cat genesis.block.in | sed "s/IP_ADDRESS/${IROHA_IP}/" >genesis.block.1st

cat docker-compose.yml.in |
  sed "s/IROHA_NODEKEY=.*/IROHA_NODEKEY=${IROHA_NODEKEY}/" >docker-compose.yml

echo "$ docker-compose -f docker-compose.yml up -d"
docker-compose -f docker-compose.yml up -d

exit 0
