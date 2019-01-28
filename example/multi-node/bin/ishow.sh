#!/bin/bash

cd ~/github.com/tkyonezu/iroha-pi/example/multi-node/block_store

if [ $# -eq 0 ]; then
  for i in *; do
    if [ "$i" = '*' ]; then
      echo ">>> block_store: EMPTY <<<"
      break
    fi

    echo ">>> $i <<<"
    python -m json.tool $i
  done | more
else
  if [ -f *$1 ]; then
    echo ">>> *$1 <<<"
    python -m json.tool *$1
  else
    echo "block: $1 not found."
    exit 1
  fi
fi

exit 0
