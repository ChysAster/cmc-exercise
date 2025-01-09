// --- [Exercise 5]: Create App Service Plan module here --- //

// --- [Parameters] ---
param appServicePlanName string
param location string = resourceGroup().location
param kind string = ''
param lockResources bool = false
@allowed([
  'Windows'
  'Linux'
])
param operatingSystem string
param tags object
param skuName string

// -- [Resources] --
// App Service Plan
resource ApplicationServicePlan 'Microsoft.Web/serverfarms@2020-05-01' = {
  name: appServicePlanName
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  kind: kind
  properties: {
    reserver: operatingSystem == 'Linux'
  }
}
// Resource Lock
resource ApplicationServicePlanLock 'Microsoft.Authorization/locks@2020-05-01' = if (lockResources) {
  name: '${appServicePlanName}-lock'
  scope: ApplicationServicePlan
  properties: {
    level: 'CanNotDelete'
    notes: 'Locked by BicepTemplate'
  }
}

// --- [Outputs] ---
output id string = ApplicationServicePlan.id
