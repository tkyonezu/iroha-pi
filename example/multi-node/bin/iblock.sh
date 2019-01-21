#!/bin/bash

echo ">>> $(hostname)"

cd ~/github.com/tkyonezu/iroha-pi/example/multi-node
echo "$ ls -l blick_store"
ls -l block_store

if [ "$(hostname)" = "iroha1" ]; then
  for i in $(seq 3); do
    n=$((i+1))
    echo ">>> iroha$n"

    ssh iroha$n "(cd ~/github.com/tkyonezu/iroha-pi/example/multi-node; \
      echo \"$ ls -l block_store\"; \
      ls -l block_store)"
  done
fi

exit 0
