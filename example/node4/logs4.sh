#!/bin/sh

#
# Copyright (c) 2017-2019 Takeshi Yonezu
# All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

IROHA_NODE="iroha-node"
TTY="/dev/"

N=$(w -h | wc -l)

w -h | sed '/ console /d' >/tmp/ilogs.$$

if [ "$(uname -s)" = "Darwin" ]; then
  TTY="/dev/tty"
fi

if [ $N -gt 4 ]; then
  N=4
fi

for i in $(seq ${N}); do
  NAME=$(cat /tmp/ilogs.$$ | sed -n ${i}p | awk '{ print $2 }')

  docker logs -f iroha-node$((i-1)) >${TTY}${NAME} &
done

rm /tmp/ilogs.$$

exit 0
