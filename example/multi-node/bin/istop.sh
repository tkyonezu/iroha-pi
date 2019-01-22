#!/bin/bash

echo ">>> $(hostname)"

COMPOSE=$(echo "docker-compose-node$(echo "$(hostname)" | sed 's/iroha//').yml")

cd ~/github.com/tkyonezu/iroha-pi/example/multi-node

echo "$ docker-compose -f ${COMPOSE} down"
docker-compose -f ${COMPOSE} down

echo "$ docker volume prune -f"
docker volume prune -f

if [ "$(hostname)" = "iroha0" ]; then
  for i in $(seq 3); do
    ssh iroha${i} bash ~/bin/istop.sh
  done
fi

exit 0
