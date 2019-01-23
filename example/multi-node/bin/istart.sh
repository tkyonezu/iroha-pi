#!/bin/bash

echo ">>> $(hostname)"

cd ~/github.com/tkyonezu/iroha-pi/example/multi-node

if [ -d block_store ]; then
  if [ "$1" = "-c" ]; then
    echo "$ rm -f block_store/*"
    rm -f block_store/*
  fi
else
  echo "$ mkdir block_store"
  mkdir block_store

  echo "$ sudo chown $(id -u):$(id -g) block_store"
  sudo chown $(id -u):$(id -g) block_store
fi

COMPOSE=$(echo "docker-compose-node$(echo "$(hostname)" | sed 's/iroha//').yml")

echo "$ docker-compose -f ${COMPOSE} up -d"
docker-compose -f ${COMPOSE} up -d

if [ "$(hostname)" = "iroha0" ]; then
  for i in $(seq 3); do
    ssh iroha${i} bash ~/bin/istart.sh $*
  done
fi

exit 0
