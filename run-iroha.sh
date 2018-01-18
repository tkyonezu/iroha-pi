#!/bin/bash

if [ "$(uname -m)" = "armv7l" ]; then
  REDIS_IMG=arm32v7/redis
  POSTGRES_IMG=arm32v7/postgres:9.5
  PROJECT=arm32v7
  IROHA_IMG=iroha-pi
  IROHA_CONF=iroha-arm32v7.conf
  WAIT_TIME=20
else
  REDIS_IMG=redis:3.2.8
  POSTGRES_IMG=postgres:9.5
  PROJECT=hyperledger
  IROHA_IMG=iroha-pi
  IROHA_CONF=iroha-x86_64.conf
  WAIT_TIME=5
fi

docker stop redis
docker rm redis

echo "# docker run -d --name redis -p6379:6379 ${REDIS_IMG}"
docker run -d --name redis -p6379:6379 ${REDIS_IMG}

docker stop postgres
docker rm postgres

echo "# docker run -d --name postgres -p5432:5432 --env POSTGRES_USER=postgres,IROHA_POSTGRES_PASSWORD=HelloW0rld ${POSTGRES_IMG}"
docker run -d --name postgres -p5432:5432 --env POSTGRES_USER=postgres,IROHA_POSTGRES_PASSWORD=HelloW0rld ${POSTGRES_IMG}

docker stop iroha-pi
docker rm iroha-pi

echo "Wait ${WAIT_TIME} seconds for PostgreSQL to be ready."
sleep ${WAIT_TIME}

echo "# docker run -t --name iroha-pi -p50051:50051 \
  --env IROHA_POSTGRES_USER=iroha,IROHA_POSTGRES_PASSWORD=HelloW0rld \
  -v $(pwd)/example:/opt/iroha/config \
  ${PROJECT}/${IROHA_IMG} \
  /opt/iroha/bin/irohad --config config/${IROHA_CONF} \
  --genesis_block config/genesis.block --keypair_name config/node0"

docker run -t --name iroha-pi -p50051:50051 \
  --env IROHA_POSTGRES_USER=iroha,IROHA_POSTGRES_PASSWORD=HelloW0rld \
  -v $(pwd)/example:/opt/iroha/config \
  ${PROJECT}/${IROHA_IMG} \
  /opt/iroha/bin/irohad --config config/${IROHA_CONF} \
  --genesis_block config/genesis.block --keypair_name config/node0

exit 0
