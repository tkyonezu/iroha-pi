#!/bin/bash
#
# Copyright (c) 2019 Takeshi Yonezu
# All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

function usage {
  echo "Usage: iroha-addpeer <node_name>"
  echo "       iroha-addpeer [ restart | logs | down | clean ]"
  exit 0
}

if [ $# -eq 0 ]; then
  usage
fi

case "$1" in
  logs)
    echo "$ docker logs -f iroha_node_1 &"
    docker logs -f iroha_node_1 &
    exit 0;;
  restart|down)
    cd example/multi-node

    echo "$ docker-compose -f docker-compose.yml $1"
    docker-compose -f docker-compose.yml $1

    exit 0;;
  clean)
    echo "$ rm -f example/multi-node/block_store/0*"
    rm -f example/multi-node/block_store/0*
    exit 0;;
esac

cd example/multi-node

cat docker-compose.yml.in |
  sed -e "s/IROHA_NODEKEY=.*/IROHA_NODEKEY=${IROHA_NODEKEY}/" >docker-compose.yml

echo "$ docker-compose -f docker-compose.yml up -d"
docker-compose -f docker-compose.yml up -d

exit 0
