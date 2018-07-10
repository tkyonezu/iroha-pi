#!/bin/sh

#
# Copyright 2018 Takeshi Yonezu. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

if [[ "$(uname -s)" == "Darwin"  && "$(uname -m)" == "x86_64" ]]; then
  SYST="MacOS"
elif [[ "$(uname -s)" == "Linux" && "$(uname -m)" == "x86_64" ]]; then
  SYST="Linux"
else
  echo "($(uname -s)/$(uname -m)) Doesn't Support."
  exit 1
fi


if [ "${SYT}" == "MacOS" ]; then
  TERM="/dev/ttys00"
  n=$(tty | sed '|/dev/ttys||')
  n=$((n+=0))
elif [ "${SYST}" == "Linux" ]; then
  TERM="/dev/pts/"
  n=$(tty | sed 's|/dev/pts/||')
fi

for i in $(seq 4); do
  docker logs -f iroha-node${i} >${TERM}$((n + i - 1)) &
done
