#!/bin/bash

CLI="../../../../iroha/target/release/iroha_client_cli"

function cli ()
{
  ${CLI} $*
}

for i in $(seq 20); do
  cli -c config-bob.json asset transfer --from bob@iroha --to alice@iroha --asset-id point#iroha --quantity 1
done

exit 0
