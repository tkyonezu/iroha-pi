#!/bin/bash
#
# Copyright (c) 2019 Takeshi Yonezu
# All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

if [ $# -lt 1 ]; then
  echo "Usage: iroha-newaccount <account_name>"
  exit 1
fi

docker exec -i iroha_node_1 iroha-cli --new_account --account_name $1

exit 0
