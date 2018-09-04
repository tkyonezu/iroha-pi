#!/bin/bash

case $(hostname) in
  kubemaster) COMPOSE="docker-compose-node0.yml";;
  kubenode1)  COMPOSE="docker-compose-node1.yml";;
  kubenode2)  COMPOSE="docker-compose-node2.yml";;
  kubenode3)  COMPOSE="docker-compose-node3.yml";;
esac

echo ">>> $(hostname)"

cd ~/github.com/tkyonezu/iroha-pi/example/multi-node

if [ "$1" = "-c" ]; then
  if [ -d block_store ]; then rm -f block_store/*; \
  else mkdir block_store; chown $(id -u):$(id -g) block_store; fi
fi

echo "$ docker-compose -f ${COMPOSE} up -d"
docker-compose -f ${COMPOSE} up -d

if [ "$(hostname)" = "kubemaster" ]; then
  for i in $(seq 3); do
    echo ">>> kubenode$i"

    COMPOSE=docker-compose-node$i.yml

    if [ "$1" = "-c" ]; then
      ssh kubenode$i "(cd ~/github.com/tkyonezu/iroha-pi/example/multi-node; \
        if [ -d block_store ]; then rm -f block_store/*; else mkdir block_store; chown $(id -u):$(id -g) block_store; fi; \
        echo \"$ docker-compose -f ${COMPOSE} up -d\"; \
        docker-compose -f ${COMPOSE} up -d)"
    else
      ssh kubenode$i "(cd ~/github.com/tkyonezu/iroha-pi/example/multi-node; \
        echo \"$ docker-compose -f ${COMPOSE} up -d\"; \
        docker-compose -f ${COMPOSE} up -d)"
    fi
  done
fi

exit 0
