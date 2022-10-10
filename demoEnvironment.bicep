targetScope = 'subscription'

param resourceGroupName string
param keyVaultName string
param resourceGroupLocation string=deployment().location

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
}

module keyVaultsModule 'keyVault.bicep' = {
  scope: resourceGroup
  name: 'keyVault'
  params: {
    location: resourceGroupLocation
    keyVaultName:keyVaultName
  }
}
