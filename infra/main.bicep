targetScope = 'resourceGroup'

@description('Azure region for deployed resources')
param location string = resourceGroup().location

@allowed([
  'dev'
  'prod'
])
@description('Deployment environment')
param environment string

@description('Virtual network address prefix')
param vnetAddressPrefix string

@description('Application subnet address prefix')
param appSubnetPrefix string

module networking './modules/networking.bicep' = {
  name: 'networking-${environment}'
  params: {
    location: location
    environment: environment
    vnetAddressPrefix: vnetAddressPrefix
    appSubnetPrefix: appSubnetPrefix
  }
}

module monitoring './modules/monitoring.bicep' = {
  name: 'monitoring-${environment}'
  params: {
    location: location
    environment: environment
  }
}

output vnetName string = networking.outputs.vnetName
output logAnalyticsWorkspaceName string = monitoring.outputs.workspaceName
