#!/bin/bash
#
# Copyright Takeshi Yonezu. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

if [ $# -eq 0 ]; then
  NUMCORE=4
else
  NUMCORE=$1
fi

TESTING=$2

## Fix max call in keys manager #1503
## https://github.com/hyperledger/iroha/pull/1503
##
## # Bug fix by implicit cast for std::max function.
## # 2018/05/19 by Takeshi Yonezu
## if [ "$(uname -m)" = "armv7l" ]; then
##   sed -i '/std::max/s/, pass_phrase/, (unsigned long)pass_phrase/' \
##     libs/crypto/keys_manager_impl.cpp
## fi

cmake -H. -Bbuild -DCMAKE_BUILD_TYPE=Release -DTESTING=${TESTING}
cmake --build build -- -j${NUMCORE}

exit 0
