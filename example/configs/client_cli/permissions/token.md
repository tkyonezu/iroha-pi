| Permission Token | Category | Operation | Args |
|------------------|----------|-----------|------|
| CanUnregisterAssetWithDefinition | Asset | Unregister | asset_definition_id |
| CanBurnAssetWithDefinition | Asset | Burn | asset_definition_id |
| CanBurnUserAssets | Asset | Burn | asset_id |
| CanSetKeyValueInUserAssets | Asset |  Definition | asset_id |
| CanRemoveKeyValueInUserAssets | Asset | Remove Key Value | asset_id |
| CanSetKeyValueInUserMetadata | Account | Set Key Value | account_id |
| CanRemoveKeyValueInUserMetadata | Account | Remove Key Value | account_id |
| CanSetKeyValueInAssetDefinition | Asset | Definition | asset_definition_id |
| CanRemoveKeyValueInAssetDefinition | Asset | Remove Key Value | asset_definition_id |
| CanMintUsetAssetDefinitions | Asset | Mint | asset_definition_id |
| CanTransferUserAssets | Asset | Transfer | asset_id |
| CanTransferOnlyFixedNumverOfTimesPerPeriod | Asset | Transfer | count: u32, period: u128 |

| CanRegisterDomains | Domain | Register | domain_id |
