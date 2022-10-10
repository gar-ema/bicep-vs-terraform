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

var frontEndAppInsightName = '${environmentName}-${environmentType}-appinsight'

resource frontEndAppInsight 'Microsoft.Insights/components@2015-05-01' = if (environmentType == 'prod') {
  name: frontEndAppInsightName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = if (environmentType == 'prod') {
  name: keyVaultName
  resource appInsightKeySecret 'secrets' = {
      name: '${environmentName}-${environmentType}-appinsightkey'
      properties: {
      value: (environmentType == 'prod') ?frontEndAppInsight.properties.InstrumentationKey:''
    }
  }
}

output appInsightInstrumentationKeySecretUri string = (environmentType == 'prod') ? keyVault::appInsightKeySecret.properties.secretUri : ''
