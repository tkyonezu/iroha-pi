#!/bin/bash

cd ..

docker stop redis
docker rm redis

docker run -d --name redis -p6379:6379 redis:3.2.8

docker stop postgres
docker rm postgres

docker run -d --name postgres -p5432:5432 --env POSTGRES_USER=postgres,POSTGRES_PASSWORD=passw0rd postgres:9.5

sleep 5

docker stop iroha-pi
docker rm iroha-pi

docker run -t --name iroha-pi -v /usr/local/src/github.com/tkyonezu/iroha-pi/example:/opt/iroha/example hyperledger/iroha-pi /opt/iroha/bin/irohad --config example/config.sample --genesis_block example/genesis.block --keypair_name example/node0

exit 0
