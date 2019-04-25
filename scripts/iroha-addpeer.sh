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

cd example/multi-node

if [ $# -eq 1 -a  "$1" = "clean" ]; then
  rm -f block_store/0*

  exit 0
fi

if [ -f block_store/0000000000000001 ]; then

  echo ">> ERROR: old genesis_block exist!!"
  exit 1
fi

if [ $# -ge 1 ]; then
  IROHA_NODEKEY=$1
else
  IROHA_NODEKEY=node0
fi

cat docker-compose.yml.in |
  sed -e "s/IROHA_NODEKEY=.*/IROHA_NODEKEY=${IROHA_NODEKEY}/" \
      -e "s/IROHA_GENESIS=.*/IROHA_GENESIS=genesis.block/" >docker-compose.yml

echo "$ docker-compose -f docker-compose.yml up -d"
docker-compose -f docker-compose.yml up -d

exit 0
