#!/bin/bash

IROHA_CONF=${IROHA_CONF:-iroha.conf}
IROHA_NODE=${IROHA_NODE:-node0}

PG_HOST=$(cat config/${IROHA_CONF} | grep pg_opt | sed -e 's/^.*host=//' -e 's/ .*//')
PG_PORT=$(cat config/${IROHA_CONF} | grep pg_opt | sed -e 's/^.*port=//' -e 's/ .*//')

/opt/iroha/bin/wait-for-it.sh -h ${PG_HOST} -p ${PG_PORT} -t 30 -- true

/opt/iroha/bin/irohad --config config/${IROHA_CONF} \
  --genesis_block config/genesis.block \
  --keypair_name config/${IROHA_NODE} \
  --overwrite_ledger
