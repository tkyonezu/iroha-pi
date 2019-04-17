#!/bin/bash

# Copyright (c) 2017-2019 Takeshi Yonezu
# All Rights Reserved.

IROHA_CONF=${IROHA_CONF:-iroha.conf}
IROHA_BLOCK=$(cat config/${IROHA_CONF} | grep block_store_path |
  sed -e 's/^.*: "//' -e 's/".*$//')
IROHA_GENESIS=${IROHA_GETNESIS:-genesis.block}
IROHA_NODEKEY=${IROHA_NODEKEY:-node0}

PG_HOST=$(cat config/${IROHA_CONF} | grep pg_opt | sed -e 's/^.*host=//' -e 's/ .*//')
PG_PORT=$(cat config/${IROHA_CONF} | grep pg_opt | sed -e 's/^.*port=//' -e 's/ .*//')

${IROHA_HOME}/bin/wait-for-it.sh -h ${PG_HOST} -p ${PG_PORT} -t 60 -- true

# Raspberry Pi, Wait until PostgreSQL is stabilized
if [ "$(uname -m)" = "armv7l" ]; then
  sleep 30
fi

cd ${IROHA_HOME}/config

if [ -f ${IROHA_BLOCK}0000000000000001 ]; then
  echo "$ irohad --config ${IROHA_CONF} --keypair_name ${IROHA_NODEKEY} --verbosity=${VERBOSITY}"

  irohad --config ${IROHA_CONF} \
    --keypair_name ${IROHA_NODEKEY}
else
  echo "$ irohad --config ${IROHA_CONF} --genesis_block ${IROHA_GENESIS} --keypair_name ${IROHA_NODEKEY} --verbosity=${VERBOSITY}"

  irohad --config ${IROHA_CONF} \
    --genesis_block ${IROHA_GENESIS} \
    --keypair_name ${IROHA_NODEKEY}
fi
