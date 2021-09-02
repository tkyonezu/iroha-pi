#!/bin/sh

#
# Copyright (c) 2021 Takeshi Yonezu
# All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

for i in $(seq 4); do
  mkdir -p iroha${i}/tmp/block_store
done

exit 0
