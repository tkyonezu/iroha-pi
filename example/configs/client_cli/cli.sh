#!/bin/bash

#----------------------------------------------------------------------#
# iroha_client_cli 2.0.0-pre-rc.9 (283eb56579e3f18e3424e8068b531706d0055a52)
#
# SUBCOMMANDS:
#   account ( grant | list | list-permissions | register | set )
#   asset   ( get | list | mint | register | transfer )
# * blocks  ( <height> )
#   domain  ( list | register )
#   events  ( data | pipeline )
# * json    ( <json> )
#   peer    ( register | unregister )
# * wasm    ( wasm [-p <path>] )
#
#----------------------------------------------------------------------#
# metrics
# $ curl http://localhost:8180/metrics
#
# iroha_client_cli
#
#   account ( grant | list | list-permissions | register | set )
#   asset   ( get | list | mint | register | transfer )
#   domain  ( list | register )
#   events  ( data | pipeline )
#   peer    ( register | unregister )
#
# genesis.block
#
#   domain register --id "wonderland"
#   account register --id "alice@wonderland"
# --key "ed01207233bfc89dcbd68c19fde6ce6158225298ec1131b6a130d1aeb454c1ab5183c0"
#   account register --id "bob@wonderland"
# --key "ed01207233bfc89dcbd68c19fde6ce6158225298ec1131b6a130d1aeb454c1ab5183c0"
#   asset register --id "rose#wonderland" --value-type "Quantity"
#     "mintable": "Infinitely" ??
#   domain register --id "garden_of_live_flowers"
#   account register --id "carpenter@garden_of_live_flowers"
# --key "ed01207233bfc89dcbd68c19fde6ce6158225298ec1131b6a130d1aeb454c1ab5183c0"
#   asset register --id "cabbage#garden_of_live_flowers" --value-type "Quantity"
#     "mintable": "Infinitely" ??
#
#   permission register --id "can_unregister_asset_with_definition"
#   permission register --id "can_burn_asset_with_definition"
#   permission register --id "can_burn_user_assets"
#   permission register --id "can_set_key_value_in_user_assets"
#   permission register --id "can_remove_key_value_in_user_assets"
#   permission register --id "can_set_key_value_in_user_metadata"
#   permission register --id "can_remove_key_value_in_user_metadata"
#   permission register --id "can_set_key_value_in_asset_definition"
#   permission register --id "can_remove_key_value_in_asset_definition"
#   permission register --id "can_mint_user_asset_definition"
#   permission register --id "can_transfer_user_assets"
#   permission register --id "can_transfer_only_fixed_number_of_times_per_period"
#
#   asset mint --account "alice@wonderland" --asset "rose#wonderland" --quantity 13
#     "AssetId": "rose##alice@wonderland"
#   asset mint --account "alice@wonderland" --asset "cabbage#garden_of_live_flowers" --quantity 13
#     "AssetId": "cabbage#garden_of_live_flowers#alice@wonderland"
#
#   permission register --id "allowed_to_do_stuff"
#
#   role register --role "USER_METADATA_ACCESS"
#     --permission "can_remove_key_value_in_user_metadata" --account "alice@wonderland"
#     --permission "can_set_key_value_in_user_metadata" --account "alice@wonderland"
#
#   permission grant --permission "allowed_to_do_stuff" --account "alice@wonderland"
#
#   role register --id "staff_that_does_stuff_in_genesis" --permission "allowed_to_do_stuff"
#----------------------------------------------------------------------#

## CLI="../../../docker/release/iroha_client_cli"
CLI="../../../../iroha/target/release/iroha_client_cli"

function cli ()
{
  ${CLI} $*
}

cli domain register --id "iroha"
cli asset register --id "point#iroha" --value-type "Quantity"
cli account register --id "alice@iroha" --key "ed01207233bfc89dcbd68c19fde6ce6158225298ec1131b6a130d1aeb454c1ab5183c0"
cli account register --id "bob@iroha" --key "ed01207233bfc89dcbd68c19fde6ce6158225298ec1131b6a130d1aeb454c1ab5183c0"
cli asset mint --account "alice@iroha" --asset "point#iroha" --quantity 5000
cli asset mint --account "bob@iroha" --asset "point#iroha" --quantity 5000

cli account grant --id "bob@iroha" --permission perms.json
cli asset transfer --from bob@iroha --to alice@iroha --asset-id point#iroha --quantity 5

exit 0
