#!/bin/bash

CLI="../../../../iroha/target/release/iroha_client_cli"

function cli ()
{
  ${CLI} $*
}

if [[ $# > 0 && "$1" == "-v" ]]; then
  VERBOSE=1
fi

for i in $(seq 20); do
  if [[ ${VERBOSE} == 1 ]]; then
    echo "$ iroha_client_cli -c config-bob.json asset transfer --from bob@iroha --to alice@iroha --asset-id point#iroha --quantity 1"
  fi
  cli -c config-bob.json asset transfer --from bob@iroha --to alice@iroha --asset-id point#iroha --quantity 1
done

exit 0
