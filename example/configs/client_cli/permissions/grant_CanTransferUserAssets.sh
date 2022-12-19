#!/bin/bash

CLI="../../../../docker/release/iroha_client_cli"

function cli ()
{
  ${CLI} $*
}

cli -c ../config-bob.json account grant --id "bob@iroha" --permission CanTransferUserAssets.json

exit 0
