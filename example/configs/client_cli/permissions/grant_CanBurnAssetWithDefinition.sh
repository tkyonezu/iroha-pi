#!/bin/bash

CLI="../../../../docker/release/iroha_client_cli"

function cli ()
{
  ${CLI} $*
}

cli -c ../config.json account grant --id "alice@iroha" --permission CanBurnAssetWithDefinition.json

exit 0
