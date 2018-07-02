#!/bin/sh

#
# Copyright 2018 Takeshi Yonezu. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

n=1

for i in $(seq 4); do
  docker logs -f iroha-node${i} >/dev/ttys00${n} &
  ((n++))
done
