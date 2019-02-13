#!/bin/bash

echo ">>> $(hostname)"

cd ~/github.com/tkyonezu/iroha-pi/example/multi-node
echo "$ rm -f block_store/*"
rm -f block_store/*

if [ "$(hostname)" = "iroha0" ]; then
  for i in $(seq 3); do
    echo ">>> iroha${i}"

    ssh iroha${i} "cd ~/github.com/tkyonezu/iroha-pi/example/multi-node; \
      echo \"$ rm -f block_store/*\"; \
      rm -f block_store/*"
  done
fi

exit 0