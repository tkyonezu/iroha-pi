#!/bin/bash

docker run -it --rm --name iroha-node-1 --entrypoint iroha-migration-tool \
  -v $(pwd)/example/node4/iroha1/block_store:/tmp/block_store \
  -v $(pwd)/example/node4/iroha1/wsv:/tmp/wsv \
  hyperledger/iroha-pi \
    --export /tmp/block_store --rocksdb_path /tmp/wsv

exit 0