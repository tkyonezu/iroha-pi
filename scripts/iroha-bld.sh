#!/bin/bash

if [ $# -eq 0 ]; then
  NUMCORE=4
else
  NUMCORE=$1
fi

TESTING="ON"
if [ "$(uname -m)" = "armv7l" ]; then
  TESTING="OFF"
fi

cmake -H. -Bbuild -DTESTING=${TESTING}
cmake --build build -- -j${NUMCORE}

exit 0
