#!/bin/bash

#
# Copyright 2018 Takeshi Yonezu. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

if [ "$(uname -m)" = "armv7l" ]; then
  PROJECT=arm32v7
else
  PROJECT=hyperledger
fi

docker run -t --rm --name iroha-pi -v $(pwd):/opt/iroha/config \
  ${PROJECT}/iroha-pi bash -c "cd /opt/iroha/config; \
    /opt/iroha/bin/iroha-cli --new_account --account_name iroha1 \
      --pass_phrase magicseed1; \
    /opt/iroha/bin/iroha-cli --new_account --account_name iroha2 \
      --pass_phrase magicseed2; \
    /opt/iroha/bin/iroha-cli --new_account --account_name iroha3 \
      --pass_phrase magicseed3; \
    /opt/iroha/bin/iroha-cli --new_account --account_name iroha4 \
      --pass_phrase magicseed4 \
    /opt/iroha/bin/iroha-cli --new_account --account_name iroha5 \
      --pass_phrase magicseed5 \
  "

exit 0