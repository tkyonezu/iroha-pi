#!/bin/bash

cd ~/github.com/tkyonezu/iroha-pi/example/multi-node/block_store

for i in *; do
  if [ "$i" = '*' ]; then
    echo ">>> block_store: EMPTY <<<"
    break
  fi

  echo ">>> $i <<<"
  python -m json.tool $i
done | more

exit 0
