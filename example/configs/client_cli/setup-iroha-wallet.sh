#!/bin/bash

CLI="../../../../iroha/target/release/iroha_client_cli"

function cli ()
{
  ${CLI} $*
}

function msg()
{
  echo "$1"
  if [[ ${INTERACTIVE} == 1 ]]; then
    echo -n ">>> Press ENTER to continue: "
    read junk
  fi
}

INTERACTIVE=0

if [[ $# > 0  && "$1" == "-i" ]]; then
  INTERACTIVE=1
fi

msg '$ iroha_client_cli domain register --id "iroha"'
cli domain register --id "iroha"

msg '$ iroha_client_cli account register --id "alice@iroha" --key "ed01207233bfc89dcbd68c19fde6ce6158225298ec1131b6a130d1aeb454c1ab5183c0"'
cli account register --id "alice@iroha" --key "ed01207233bfc89dcbd68c19fde6ce6158225298ec1131b6a130d1aeb454c1ab5183c0"

msg '$ iroha_client_cli account register --id "bob@iroha" --key "ed01207233bfc89dcbd68c19fde6ce6158225298ec1131b6a130d1aeb454c1ab5183c0"'
cli account register --id "bob@iroha" --key "ed01207233bfc89dcbd68c19fde6ce6158225298ec1131b6a130d1aeb454c1ab5183c0"

msg '$ iroha_client_cli asset register --id "point#iroha" --value-type "Quantity"'
cli asset register --id "point#iroha" --value-type "Quantity"

msg '$ iroha_client_cli asset mint --account "alice@iroha" --asset "point#iroha" --quantity 5000'
cli asset mint --account "alice@iroha" --asset "point#iroha" --quantity 5000

msg '$ iroha_client_cli asset mint --account "bob@iroha" --asset "point#iroha" --quantity 5000'
cli asset mint --account "bob@iroha" --asset "point#iroha" --quantity 5000

## msg '$ iroha_client_cli  account grant --id "bob@iroha" --permission perms.json'
## cli account grant --id "bob@iroha" --permission perms.json

msg '$ iroha_client_cli -c config-bob.json asset transfer --from bob@iroha --to alice@iroha --asset-id point#iroha --quantity 5'
cli -c config-bob.json asset transfer --from bob@iroha --to alice@iroha --asset-id point#iroha --quantity 5

msg '$ iroha_client_cli -c config-alice.json asset transfer --from alice@iroha --to bob@iroha --asset-id point#iroha --quantity 100'
cli -c config-alice.json asset transfer --from alice@iroha --to bob@iroha --asset-id point#iroha --quantity 100

exit 0
