#!/bin/bash

[ -d release ] || mkdir release
[ -d debug ] || mkdir debug

for i in release debug; do
  for j in iroha iroha_client_cli kagami kura_inspector parity_scale_decoder; do
    if [ -x ../../iroha/target/${i}/${j} ]; then
      echo "$ rsync -av ../../iroha/target/${i}/${j} ${i}/."
      rsync -av ../../iroha/target/${i}/${j} ${i}/.
    fi
  done
done

exit 0
