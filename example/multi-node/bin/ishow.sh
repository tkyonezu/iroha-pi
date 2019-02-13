#!/bin/bash

# Copyright (c) 2017-2019 Takeshi Yonezu
# All Rights Reserved.

cd ~/github.com/tkyonezu/iroha-pi/example/multi-node/block_store

if [ $# -eq 0 ]; then
  for i in *; do
    if [ "$i" = '*' ]; then
      echo ">>> block_store: EMPTY <<<"
      break
    fi

    echo ">>> $i ($(python -m json.tool $i | grep commands | wc -l)) <<<"
    python -m json.tool $i
  done | more
else
  if [ -f *$1 ]; then
    BLOCK=$(ls *$1 2>/dev/null)

    echo ">>> ${BLOCK} ($(python -m json.tool ${BLOCK} | grep commands | wc -l)) <<<"
    python -m json.tool ${BLOCK} | more
  else
    echo "block: $1 not found."
    exit 1
  fi
fi

exit 0
