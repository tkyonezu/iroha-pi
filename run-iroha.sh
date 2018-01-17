#!/bin/bash

IMG=iroha-pi

docker stop redis
docker rm redis

echo "# docker run -d --name redis -p6379:6379 redis:3.2.8"
docker run -d --name redis -p6379:6379 redis:3.2.8

docker stop postgres
docker rm postgres

echo "# docker run -d --name postgres -p5432:5432 --env POSTGRES_USER=postgres,IROHA_POSTGRES_PASSWORD=HelloW0rld postgres:9.5"
docker run -d --name postgres -p5432:5432 --env POSTGRES_USER=postgres,IROHA_POSTGRES_PASSWORD=HelloW0rld postgres:9.5

docker stop iroha-pi
docker rm iroha-pi

sleep 5

echo "# docker run -t --name iroha-pi -p50051:50051 \
  --env IROHA_POSTGRES_USER=iroha,IROHA_POSTGRES_PASSWORD=HelloW0rld \
  -v /usr/local/src/github.com/soramitsu/iroha-pi/example:/opt/iroha/config \
  hyperledger/${IMG} \
  /opt/iroha/bin/irohad --config config/iroha.conf \
  --genesis_block config/genesis.block --keypair_name config/node0"

docker run -t --name iroha-pi -p50051:50051 \
  --env IROHA_POSTGRES_USER=iroha,IROHA_POSTGRES_PASSWORD=HelloW0rld \
  -v /usr/local/src/github.com/soramitsu/iroha-pi/example:/opt/iroha/config \
  hyperledger/${IMG} \
  /opt/iroha/bin/irohad --config config/iroha.conf \
  --genesis_block config/genesis.block --keypair_name config/node0

exit 0
