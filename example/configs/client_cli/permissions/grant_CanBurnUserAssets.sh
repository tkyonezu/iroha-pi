#!/bin/bash

CLI="../../../../docker/release/iroha_client_cli"

function cli ()
{
  ${CLI} $*
}

cli -c ../config-alice.json account grant --id "alice@iroha" --permission CanBurnUserAssets.json

exit 0
