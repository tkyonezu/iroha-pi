#!/bin/bash

case $(hostname) in
  iroha1) COMPOSE="docker-compose-node1.yml";;
  iroha2) COMPOSE="docker-compose-node2.yml";;
  iroha3) COMPOSE="docker-compose-node3.yml";;
  iroha4) COMPOSE="docker-compose-node4.yml";;
esac

echo ">>> $(hostname)"

cd ~/github.com/tkyonezu/iroha-pi/example/multi-node
echo "$ docker-compose -f ${COMPOSE} down"
docker-compose -f ${COMPOSE} down
echo "$ docker volume prune -f"
docker volume prune -f

if [ "$(hostname)" = "iroha1" ]; then
  for i in $(seq 3); do
    n=$((i+1))
    echo ">>> iroha$n"

    COMPOSE=docker-compose-node$n.yml

    ssh iroha$n "(cd ~/github.com/tkyonezu/iroha-pi/example/multi-node; \
      echo \"$ docker-compose -f ${COMPOSE} down\"; \
      docker-compose -f ${COMPOSE} down; \
      echo \"$ docker volume prune -f\"; \
      docker volume prune -f)"
  done
fi

exit 0
