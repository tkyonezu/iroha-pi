#!/bin/bash

CLI="../../../../iroha/target/release/iroha_client_cli"

function cli ()
{
  ${CLI} $*
}

echo '$ iroha_client_cli domain register --id "iroha"'
read junk
cli domain register --id "iroha"

echo '$ iroha_client_cli account register --id "alice@iroha" --key "ed01207233bfc89dcbd68c19fde6ce6158225298ec1131b6a130d1aeb454c1ab5183c0"'
read junk
cli account register --id "alice@iroha" --key "ed01207233bfc89dcbd68c19fde6ce6158225298ec1131b6a130d1aeb454c1ab5183c0"

echo '$ iroha_client_cli account register --id "bob@iroha" --key "ed01207233bfc89dcbd68c19fde6ce6158225298ec1131b6a130d1aeb454c1ab5183c0"'
read junk
cli account register --id "bob@iroha" --key "ed01207233bfc89dcbd68c19fde6ce6158225298ec1131b6a130d1aeb454c1ab5183c0"

echo '$ iroha_client_cli asset register --id "point#iroha" --value-type "Quantity"'
read junk
cli asset register --id "point#iroha" --value-type "Quantity"

echo '$ iroha_client_cli asset mint --account "alice@iroha" --asset "point#iroha" --quantity 5000'
read junk
cli asset mint --account "alice@iroha" --asset "point#iroha" --quantity 5000

echo '$ iroha_client_cli asset mint --account "bob@iroha" --asset "point#iroha" --quantity 5000'
read junk
cli asset mint --account "bob@iroha" --asset "point#iroha" --quantity 5000

## echo '$ iroha_client_cli  account grant --id "bob@iroha" --permission perms.json'
## read junk
## cli account grant --id "bob@iroha" --permission perms.json

echo '$ iroha_client_cli -c config-bob.json asset transfer --from bob@iroha --to alice@iroha --asset-id point#iroha --quantity 5'
read junk
cli -c config-bob.json asset transfer --from bob@iroha --to alice@iroha --asset-id point#iroha --quantity 5

echo '$ iroha_client_cli -c config-alice.json asset transfer --from alice@iroha --to bob@iroha --asset-id point#iroha --quantity 100'
read junk
cli -c config-alice.json asset transfer --from alice@iroha --to bob@iroha --asset-id point#iroha --quantity 100

exit 0
