// --------------
// - Parameters -
// --------------
@minLength(3)
@maxLength(6)
@description('The name of the environment. You can use a string from 3 to 6 character lenght.')
param environmentName string = 'bicep'

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

// -----------
// - Modules -
// -----------
module frontEndLayer 'modules/frontEndLayer.bicep' = {
  name: 'frontEndLayer'
  params: {
    location: location
    environmentName: environmentName
    environmentType: environmentType
    appInsightInstrumentationKeySecretUri: (environmentType == 'prod') ? monitoringLayer.outputs.appInsightInstrumentationKeySecretUri : ''
    storageConnectionStringSecretUri: dataLayer.outputs.storageAccountSecretUri
    keyVaultName: keyVaultName
  }
}

module dataLayer 'modules/dataLayer.bicep' = {
  name: 'dataLayer'
  params: {
    location: location
    environmentName: environmentName
    environmentType: environmentType
    keyVaultName: keyVaultName
  }
}

module monitoringLayer 'modules/monitoringLayer.bicep' = {
  name: 'monitoringLayer'
  params: {
    location: location
    environmentName: environmentName
    environmentType: environmentType
    keyVaultName: keyVaultName
  }
}

// -----------
// - Outputs -
// -----------
output appServiceAppHostName string = frontEndLayer.outputs.appServiceAppHostName
