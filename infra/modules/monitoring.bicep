@description('Azure region for deployed resources')
param location string

@description('Deployment environment')
param environment string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'law-cicd-${environment}'
  location: location
  tags: {
    Environment: environment
    ManagedBy: 'Bicep'
    Project: 'CICDInfrastructurePipeline'
    CostCenter: 'CloudLab'
  }
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

output workspaceName string = logAnalytics.name
output workspaceId string = logAnalytics.id
