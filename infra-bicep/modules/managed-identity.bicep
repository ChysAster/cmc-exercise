// --- [Exercise 1]: Create Managed Identity module here --- //

// --- [Parameters] ---
@description('The name of the user-assigned managed identity')
param managedIdentityName string

@description('The location for all the resources in the managed identity module')
param location string = resourceGroup().location

@description('An object of key-value pairs of tags.')
param tags object = {}

// --- [Resources] ---
resource ManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
  tags: tags
}
// --- [Outputs] ---
output resourceId string = ManagedIdentity.id
output objectId string = ManagedIdentity.properties.principalId
output name string = ManagedIdentity.name
output clientId string = ManagedIdentity.properties.clientId
