// --- [Exercise 6]: Create Web App module here --- //

// --- [Parameters] ---
param location string = resourceGroup().location

param appServiceName string
param appServicePlanId string
param lockResources bool
param appSettings array
param linuxFxVersion string
param identityClientId string
param identityResourceId string

param sharedResourceGroupName string

param tags object

// -- [Resources] --
// App Service
resource app_service'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceName
  location: location
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities:{
      '${identityResourceId}': {}
    }
  }
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      appSettings: appSettings
      linuxFxVersion: linuxFxVersion
      acrUseManagedIdentityCreds: true
      acrUserManagedIdentityID: identityClientId
      vnetRouteAllEnabled: true
    }
    keyVaultReferenceIdentity: identityResourceId

    virtualNetworkSubnetId: resourceId(subscription().subscriptionId, sharedResourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', 'vnet-trac-shared', 'snet-asp-weu-001')
  }
}
// Vnet Integration
resource vnet_integration 'Microsoft.Web/sites/virtualNetworkConnections@2022-09-01' = {
  name: 'snet-asp-weu-001'
  parent: app_service
  properties: {
    vnetResourceId: resourceId(subscription().subscriptionId, sharedResourceGroupName, 'Microsoft.Network/virtualNetworks', 'vnet-trac-shared')
  }
}
// Resource Lock
resource lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockResources) {
  name: '${app_service.name}-Lock'
  scope: app_service
  properties: {
    level: 'CanNotDelete' //NotSpecified, CanNotDelete, ReadOnly
    notes: 'Locked by BicepTemplate'
  }
}
// --- [Outputs] ---
