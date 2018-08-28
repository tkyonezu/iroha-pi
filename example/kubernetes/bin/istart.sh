#!/bin/bash

echo ">>> $(hostname)"

case $(hostname) in
  kubemaster) COMPOSE="docker-compose-node0.yml";;
  kubenode1)  COMPOSE="docker-compose-node1.yml";;
  kubenode2)  COMPOSE="docker-compose-node2.yml";;
  kubenode3)  COMPOSE="docker-compose-node3.yml";;
esac

cd ~/github.com/tkyonezu/iroha-pi/example/kubernetes
[ -d block_store ] || mkdir block_store
echo "$ docker-compose -f ${COMPOSE} up -d"
docker-compose -f ${COMPOSE} up -d

if [ "$(hostname)" = "kubemaster" ]; then
  for i in $(seq 3); do
    echo ">>> kubenode$i"

    COMPOSE=docker-compose-node$i.yml

    ssh kubenode$i "(cd ~/github.com/tkyonezu/iroha-pi/example/kubernetes; \
      [ -d block_store ] || mkdir block_store; \
      echo \"$ docker-compose -f ${COMPOSE} up -d\"; \
      docker-compose -f ${COMPOSE} up -d)"
  done
fi

exit 0
