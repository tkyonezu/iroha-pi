#!/bin/bash

# Copyright (c) 2017-2019 Takeshi Yonezu
# All Rights Reserved.

if [ $# -gt 0 ]; then
  echo "$ ssh $1 bash ~/bin/irestart.sh"
  ssh $1 bash ~/bin/irestart.sh
else
  bash ~/bin/istop.sh
  sleep 3
  bash ~/bin/istart.sh
fi

exit 0
