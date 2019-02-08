#!/bin/sh

#
# Copyright 2018, 2019 Takeshi Yonezu. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

N=$(w -h | wc -l)

w -h >/tmp/ilogs.$$

for i in $(seq ${N}); do
  TTY_NAME=$(cat /tmp/ilogs.$$ | sed -n ${i}p | awk '{ print $2 }')

  docker logs -f iroha-node$((i-1)) >/dev/${TTY_NAME} &
done

rm /tmp/ilogs.$$

exit 0
