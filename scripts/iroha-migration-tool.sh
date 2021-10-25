#!/bin/bash

docker run -it --rm --entrypoint iroha-migration-tool \
  -v $(pwd)/example/node4/iroha1/block_store:/tmp/block_store \
  -v $(pwd)/example/node4/iroha1/wsv:/tmp/wsv \
  hyperledger/iroha-pi \
    --block_store_path /tmp/block_store --rocksdb_path /tmp/wsv

exit 0
