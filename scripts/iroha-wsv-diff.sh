#!/bin/bash

docker network create iroha_default

docker run -d --rm --name iroha-postgres-1 \
  --network iroha_default \
  --env POSTGRES_USER=iroha --env POSTGRES_PASSWORD=HelloW0rld \
  -v $(pwd)/example/node4/iroha1/var/lib/postgresql/data:/var/lib/postgresql/data \
  postgres:13-alpine

docker run -it --rm --name iroha-node-1 \
  --network iroha_default \
  --entrypoint iroha-wsv-diff \
  -v $(pwd)/example/node4/iroha1/wsv:/tmp/wsv \
  -v $(pwd)/example/node4/iroha1:/opt/iroha/config \
  hyperledger/iroha-pi \
    --pg_opt "dbname=iroha_default host=iroha-postgres-1 port=5432 user=iroha password=HelloW0rld" --rocksdb_path /tmp/wsv

echo

docker stop iroha-postgres-1 >/dev/null

docker network rm iroha_default >/dev/null

exit 0
