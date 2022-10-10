targetScope = 'subscription'

param resourceGroupName string
param keyVaultName string
param keyVaultResourceGroup string
param resourceGroupLocation string=deployment().location

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
}

resource kvResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: keyVaultResourceGroup
  location: resourceGroupLocation
}

module keyVaultsModule 'keyVault.bicep' = {
  scope: kvResourceGroup
  name: 'keyVault'
  params: {
    location: resourceGroupLocation
    keyVaultName:keyVaultName
  }
}
