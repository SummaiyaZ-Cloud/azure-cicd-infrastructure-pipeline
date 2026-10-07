@description('Azure region for deployed resources')
param location string

@description('Deployment environment')
param environment string

@description('Virtual network address prefix')
param vnetAddressPrefix string

@description('Application subnet address prefix')
param appSubnetPrefix string

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: 'vnet-cicd-${environment}'
  location: location
  tags: {
    Environment: environment
    ManagedBy: 'Bicep'
    Project: 'CICDInfrastructurePipeline'
    CostCenter: 'CloudLab'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
  }
}

resource appSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: vnet
  name: 'snet-app'
  properties: {
    addressPrefix: appSubnetPrefix
  }
}

output vnetName string = vnet.name
output vnetId string = vnet.id
output appSubnetId string = appSubnet.id
