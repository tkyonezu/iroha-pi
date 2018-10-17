#!/bin/bash

case $(hostname) in
  kubemaster) COMPOSE="docker-compose-node0.yml";;
  kubenode1)  COMPOSE="docker-compose-node1.yml";;
  kubenode2)  COMPOSE="docker-compose-node2.yml";;
  kubenode3)  COMPOSE="docker-compose-node3.yml";;
esac

echo ">>> $(hostname)"

cd ~/github.com/tkyonezu/iroha-pi/example/multi-node
echo "$ docker-compose -f ${COMPOSE} down"
docker-compose -f ${COMPOSE} down
echo "$ docker volume prune -f"
docker volume prune -f

if [ "$(hostname)" = "kubemaster" ]; then
  for i in $(seq 3); do
    echo ">>> kubenode$i"

    COMPOSE=docker-compose-node$i.yml

    ssh kubenode$i "(cd ~/github.com/tkyonezu/iroha-pi/example/multi-node; \
      echo \"$ docker-compose -f ${COMPOSE} down\"; \
      docker-compose -f ${COMPOSE} down; \
      echo \"$ docker volume prune -f\"; \
      docker volume prune -f)"
  done
fi

exit 0
