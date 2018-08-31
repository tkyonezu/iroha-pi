#!/usr/bin/env bash

mkdir key
cp config/admin_test.priv key/admin@test.priv
cp config/admin_test.pub  key/admin@test.pub
cp config/alice_test.priv key/alice@test.priv
cp config/alice_test.pub  key/alice@test.pub
cp config/bob_test.priv   key/bob@test.priv
cp config/bob_test.pub    key/bob@test.pub

KEY=$(echo $KEY | cut -d'-' -f2)

sleep 20

irohad --genesis_block config/genesis.block --config config/iroha.conf --keypair_name config/kubenode$KEY
