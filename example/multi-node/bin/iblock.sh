#!/bin/bash

echo ">>> $(hostname)"

cd ~/github.com/tkyonezu/iroha-pi/example/kubernetes
echo "$ ls -l blick_store"
ls -l block_store

if [ "$(hostname)" = "kubemaster" ]; then
  for i in $(seq 3); do
    echo ">>> kubenode$i"

    ssh kubenode$i "(cd ~/github.com/tkyonezu/iroha-pi/example/kubernetes; \
      echo \"$ ls -l block_store\"; \
      ls -l block_store)"
  done
fi

exit 0
