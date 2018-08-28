#!/bin/bash

docker logs -f iroha_node_1 >/dev/pts/0 &

exit 0
