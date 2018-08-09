#!/bin/bash
#
# Copyright Takeshi Yonezu. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

IROHA_HOME=/opt/iroha
PI_HOME=$(pwd)/docker/iroha

rm -fr ${PI_HOME}

LIBS=$(ldd ${IROHA_HOME}/build/bin/irohad | cut -f2 | cut -d" " -f3)
mkdir -p ${PI_HOME}/lib
cp -H ${LIBS} ${PI_HOME}/lib

cd ${PI_HOME}/lib
rm -f libc.so.* libdl.so.* libgcc_s.so.* libm.so.* libpthread.so.* librt.so.* libstdc++.so.* libz.so.*

cp -r ${IROHA_HOME}/build/bin ${PI_HOME}
## cp -r ${IROHA_HOME}/build/test_bin ${PI_HOME}

cd ${PI_HOME}/bin
strip irohad iroha-cli

exit 0
