@minLength(3)
@maxLength(6)
@description('The name of the environment. You can use a string from 3 to 6 character lenght.')
param environmentName string

@allowed([
  'dev'
  'prod'
])
@description('The environment type. Choose one of the dev or prod value.')
param environmentType string

@description('Location for the environment')
param location string = resourceGroup().location

@description('Name of the Key vault contains the SQL admin password')
param keyVaultName string

var storageAccountName = toLower('${environmentName}${environmentType}${uniqueString(subscription().id)}')

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyVaultName
  resource storageSecret 'secrets' = {
      name: '${environmentName}-${environmentType}-storageconnstring'
      properties: {
      value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
    }
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

output storageAccountSecretUri string = keyVault::storageSecret.properties.secretUri

