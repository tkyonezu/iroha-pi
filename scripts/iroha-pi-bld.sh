#!/bin/bash

if [ $# -eq 0 ]; then
  NUMCORE=4
else
  NUMCORE=$1
fi

cmake -H. -Bbuild
cmake --build build -- -j${NUMCORE}

exit 0
