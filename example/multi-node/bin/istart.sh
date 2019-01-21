#!/bin/bash

case $(hostname) in
  iroha1) COMPOSE="docker-compose-node1.yml";;
  iroha2) COMPOSE="docker-compose-node2.yml";;
  iroha3) COMPOSE="docker-compose-node3.yml";;
  iroha4) COMPOSE="docker-compose-node4.yml";;
esac

echo ">>> $(hostname)"

cd ~/github.com/tkyonezu/iroha-pi/example/multi-node

if [ "$1" = "-c" ]; then
  rm -f block_store/*
fi

if [ ! -d block_store ]; then
  mkdir block_store
  chown $(id -u):$(id -g) block_store
fi

echo "$ docker-compose -f ${COMPOSE} up -d"
docker-compose -f ${COMPOSE} up -d

if [ "$(hostname)" = "iroha1" ]; then
  for i in $(seq 3); do
    n=$((i+1))
    echo ">>> iroha$n"

    COMPOSE=docker-compose-node$n.yml

    if [ "$1" = "-c" ]; then
      ssh iroha$n "(cd ~/github.com/tkyonezu/iroha-pi/example/multi-node; \
        if [ -d block_store ]; then rm -f block_store/*; else mkdir block_store; chown $(id -u):$(id -g) block_store; fi; \
        echo \"$ docker-compose -f ${COMPOSE} up -d\"; \
        docker-compose -f ${COMPOSE} up -d)"
    else
      ssh iroha$n "(cd ~/github.com/tkyonezu/iroha-pi/example/multi-node; \
        echo \"$ docker-compose -f ${COMPOSE} up -d\"; \
        docker-compose -f ${COMPOSE} up -d)"
    fi
  done
fi

exit 0
