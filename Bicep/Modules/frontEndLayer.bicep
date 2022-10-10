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

@description('Secret Uri for the storage connection string')
param storageConnectionStringSecretUri string

@description('Secret Uri for the application Insight key')
param appInsightInstrumentationKeySecretUri string

@description('Location for the environment')
param location string = resourceGroup().location

@description('Name of the Key vault contains the SQL admin password')
param keyVaultName string

var frontEndAppName = '${environmentName}${environmentType}-${uniqueString(subscription().id)}-app'
var frontEndAppPlanName = '${environmentName}${environmentType}-${uniqueString(subscription().id)}-plan'

var appPlanConfigurationMap = {
  prod : {
    appServicePlan: {
      sku: {
        name: 'P1'
        tier: 'Premium'
      }
    }
  }
  dev : {
    appServicePlan: {
      sku: {
        name: 'F1'
        tier: 'Free'
      }
    }
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyVaultName
}

resource appServiceKeyVaultAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('Key Vault Secret User', frontEndAppName, subscription().subscriptionId)
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6') // this is the role "Key Vault Secrets User"
    principalId: frontEndAppService.identity.principalId
    principalType: 'ServicePrincipal'
  }
  dependsOn: [
    keyVault
  ]
}

resource frontEndAppService 'Microsoft.Web/sites@2021-01-01' = {
  name: frontEndAppName
  location: location
  kind: 'app'
  properties: {
    enabled: true
    serverFarmId: frontEndAppServicePlan.id
  }
  identity:{
    type: 'SystemAssigned'
  }
}

resource appSettings 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'appsettings'
  parent: frontEndAppService
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY:(environmentType == 'prod') ?  '@Microsoft.KeyVault(SecretUri=${appInsightInstrumentationKeySecretUri})' : ''
    StorageConnectionString: '@Microsoft.KeyVault(SecretUri=${storageConnectionStringSecretUri})'
  }
  dependsOn:[
    keyVault
    appServiceKeyVaultAssignment
  ]
}

resource frontEndAppServicePlan 'Microsoft.Web/serverfarms@2021-01-01'={
  name : frontEndAppPlanName
  location: location
  sku : appPlanConfigurationMap[environmentType].appServicePlan.sku
}

output appServiceAppHostName string = 'https://${frontEndAppService.properties.defaultHostName}'
