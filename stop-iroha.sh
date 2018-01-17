#!/bin/bash

for i in iroha-pi postgres redis; do
  echo "# docker stop $i"
  docker stop $i

  echo "# docker rm $i"
  docker rm $i
done

exit 0
