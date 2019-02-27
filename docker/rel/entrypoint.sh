#!/bin/bash

# Copyright (c) 2017-2019 Takeshi Yonezu
# All Rights Reserved.

IROHA_CONF=${IROHA_CONF:-iroha.conf}
IROHA_NODEKEY=${IROHA_NODEKEY:-node0}
IROHA_BLOCK=$(cat config/${IROHA_CONF} | grep block_store_path |
  sed -e 's/^.*: "//' -e 's/".*$//')

PG_HOST=$(cat config/${IROHA_CONF} | grep pg_opt | sed -e 's/^.*host=//' -e 's/ .*//')
PG_PORT=$(cat config/${IROHA_CONF} | grep pg_opt | sed -e 's/^.*port=//' -e 's/ .*//')

/opt/iroha/bin/wait-for-it.sh -h ${PG_HOST} -p ${PG_PORT} -t 60 -- true

# Raspberry Pi, Wait until PostgreSQL is stabilized
if [ "$(uname -m)" = "armv7l" ]; then
  sleep 30
fi

echo "$ /opt/iroha/bin/irohad --config config/${IROHA_CONF} --genesis_block config/genesis.block --keypair_name config/${IROHA_NODEKEY}"

/opt/iroha/bin/irohad --config config/${IROHA_CONF} \
  --genesis_block config/genesis.block \
  --keypair_name config/${IROHA_NODEKEY}
