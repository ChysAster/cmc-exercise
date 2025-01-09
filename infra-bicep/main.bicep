// --- [Parameters] ---
@allowed([
  'bicep'
])
param environmentName string
param location string = resourceGroup().location
param lockResources bool
param starterName string

@secure()
param sqlDatabasePassword string

// Actions Environment Viariables
param githubRunNumber string
param sharedResourceGroupName string
param acrName string
param acrUsername string
@secure()
param acrPassword string

// Add Parameter

var bootcampStartersObjectId = 'e05a17d6-9642-4726-b548-ee5fe82100a1' // # Add object ID of your user
var serviceConnectionObjectId = '1ab308e4-f3b0-430a-9e86-61889716676c' // solution-trac-2024-iac 
var tags = {
  WorkloadName: 'Analyst Bootcamp'
  Criticality: 'Low'
  Environment: environmentName
  Starter: starterName
}

// --- [Exercise 1]: Call Managed Identity module here --- //
module managed_identity 'modules/managed-identity.bicep' = {
  name: '${environmentName}-${starterName}-manged-identity-${githubRunNumber}'
  params: {
    location: location
    managedIdentityName: '${environmentName}-${starterName}-manged-identity-${githubRunNumber}'
    tags: tags
  }
}


// --- [Exercise 2]: Call Key Vault module from ACR (version 8) --- //
module keyvault 'modules/keyvault.bicep' = {
  name: '${environmentName}-${starterName}-keyvault-${githubRunNumber}'
  params: {
    keyVaultName: '${environmentName}-${starterName}-keyvault-${githubRunNumber}'
    location: location
    publicNetworkAccess: 'Enabled'
    privateEndpoints: [
      {
        name: '${environmentName}-${starterName}-keyvault-pe'
        subnetId: '/subscriptions/79a81a33-0d1a-45a4-bf46-b5355653beba/resourceGroups/RG_Aster.Chys/providers/Microsoft.Network/virtualNetworks/<vnet-name>/subnets/<subnet-name>'
      }
    ]
    tags: tags
    accessPolicies: [
      {
        objectId: bootcampStartersObjectId
        tenantId: subscription().tenantId
        permissions: {
          secrets: ['all']
        }
      }
      {
        objectId: serviceConnectionObjectId
        tenantId: subscription().tenantId
        permissions: {
          secrets: ['all']
        }
      }
    ]
  }
}
// --- [Exercise 3]: Add existing SQL Server 'sql-trac-shared'from shared resource group --- //
resource sql_server 'Microsoft.Sql/servers@2021-11-01' existing = {
  name: 'sql-trac-shared-aster'
  scope: resourceGroup(sharedResourceGroupName)
}

// --- [Exercise 4]: Call Database module here --- //
module database 'modules/sql-database.bicep' = {
  name: '${environmentName}-${starterName}-database-${githubRunNumber}'
  params: {
    databaseName: '${environmentName}-${starterName}-database-${githubRunNumber}'
    enableTransparentDataEncryption: 'Enabled'
    location: location
    skuName: 'S0'
    sqlServerName: sql_server.name
    tags: tags
  }
}

// --- [Exercise 5]: Call App Service Plan module here --- //
module app_service_plan 'modules/app-service-plan.bicep' = {
  name: '${environmentName}-${starterName}-app-service-plan-${githubRunNumber}'
  params: {
    appServicePlanName: '${environmentName}-${starterName}-app-service-plan-${githubRunNumber}'
    location: location
    lockResources: lockResources
    operatingSystem: 'Linux'
    skuName: 'B1'
    tags: tags
  }
}


// --- [Exercise 6]: Call Web App module here --- //
module web_app 'modules/web-app.bicep' = {
  name: '${environmentName}-${starterName}-web-app-${githubRunNumber}'
  params: {
    appServiceName: '${environmentName}-${starterName}-web-app-${githubRunNumber}'
    appServicePlanId: app_service_plan.outputs.id
    appSettings: [
      {
        name: 'KEYVAULT_VALUE'
        value: '@Microsoft.KeyVault(VaultName=${keyvault.outputs.name};SecretName=webapp-secret)'
      }
      {
        name: 'DB_CONNECTION_STRING'
        value: 'Driver={ODBC Driver 18 for SQL Server};Server=${sql_server.name}.database.windows.net,1433;Database=${database.outputs.databaseName};Uid=sqladmin;Pwd=${sqlDatabasePassword}'
      }
    ]
    identityClientId: managed_identity.outputs.clientId
    identityResourceId: managed_identity.outputs.resourceId
    location: location
    linuxFxVersion: 'NODE|14-lts'
    lockResources: lockResources
    sharedResourceGroupName: sharedResourceGroupName
    tags: tags
  }
}
