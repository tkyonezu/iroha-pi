#!/usr/bin/env bash
sed -ri "s/host=.*( port=.*)/host=${pg-host}\1/" iroha.conf
KEY=$(echo $KEY | cut -d'-' -f2)
sleep 20
irohad --genesis_block genesis.block --config iroha.conf --keypair_name kubenode$KEY
