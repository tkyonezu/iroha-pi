#!/bin/bash

# Copyright (c) 2017-2019 Takeshi Yonezu
# All Rights Reserved.

echo "$ docker logs -f iroha_node_1 &"
docker logs -f iroha_node_1 &

exit 0
