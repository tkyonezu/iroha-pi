#!/bin/bash
#
# Copyright Takeshi Yonezu. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

IROHA_HOME=/opt/iroha
PI_HOME=docker/iroha

rm -fr ${PI_HOME}

LIBS=$(ldd ${IROHA_HOME}/build/bin/irohad | cut -f 2 | cut -d " " -f 3)
mkdir -p ${PI_HOME}/lib
cp -H ${LIBS} ${PI_HOME}/lib

cp -r ${IROHA_HOME}/build/bin ${PI_HOME}
## cp -r ${IROHA_HOME}/build/test_bin ${PI_HOME}

exit 0
