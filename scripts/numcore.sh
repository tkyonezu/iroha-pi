#!/bin/bash
#
# Copyright (c) 2017-2019 Takeshi Yonezu
# All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

UKERNEL=$(uname -s)
UMACHINE=$(uname -m)

if [ "${UKERNEL}" = "Linux" ]; then
  NUMCORE=$(grep processor /proc/cpuinfo | wc -l)

  # Linux/x86_64
  if [ "${UMACHINE}" = "x86_64" ]; then
    # Intel(R) Atom(TM)
    CPU_MODEL=$(grep "^model name" /proc/cpuinfo |
      sed 1q | sed 's/^model name.*: //' | awk '{ print $1 " " $2 }')

    if [ "${CPU_MODEL}" = "Intel(R) Atom(TM)" ]; then
      if [ ${NUMCORE} -gt 2 ]; then
        NUMCORE=2
      fi
    fi

    # Microsoft Windows Service for Linux
    if echo $(uname -v) | grep -q Microsoft; then
      if [ ${NUMCORE} -gt 2 ]; then
        NUMCORE=2
      fi
    fi
  # Linux/armv7l (Raspberry Pi3)
  elif [ "${UMACHINE}" = "armv7l" ]; then
    NUMCORE=2
  elif [ "${UMACHINE}" != "aarch64" ]; then
    NUMCORE=1
  fi
elif [ "${UKERNEL}" = "Darwin" ]; then
  # MacOS (Intel)
  if [ "${UMACHINE}" = "x86_64" ]; then
    NUMCORE=$(system_profiler SPHardwareDataType | grep Cores |
      sed 's/^.*Cores: //')
##  NUMCORE=$(sysctl -n hw.ncpu)
    if [ ${NUMCORE} -gt 2 ]; then
      NUMCORE=2		# Force CPU=2
    fi
  else
    NUMCORE=1
  fi
else
  NUMCORE=1
fi

echo ${NUMCORE}
