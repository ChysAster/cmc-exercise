// --- [Exercise 4]: Create Database module here --- //

// --- [Parameters] ---
@description('The location for all the resources in the Azure SQL module')
param location string = resourceGroup().location

@description('The SQL Server name')
param sqlServerName string

@description('Name of the database')
param databaseName string

@description('An object of key-value pairs of tags (Default: "{}") ')
param tags object

var databaseCollation = 'SQL_Latin1_General_CP1_CI_AS'

@allowed([
  'Enabled'
  'Disabled'
])
param enableTransparentDataEncryption string = 'Enabled'

@allowed([
  'S0'
  'S1'
  'S2'
  'P1'
])
param skuName string = 'S0'

// -- [Resources] --
// Database
resource database 'Microsoft.Sql/servers/databases@2021-11-01' = {
  name: '${sqlServerName}/${databaseName}'
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
  }
}
// Transparent Data Encryption
resource transparent_data_encryption 'Microsoft.Sql/servers/databases/transparentDataEncryption@2021-11-01' = {
  name: 'current'
  parent: database
  properties: {
    state: enableTransparentDataEncryption
  }

}

resource backup_long_term 'Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies@2021-11-01' = {
  name: 'default'
  parent: database
  properties: {
    weeklyRetention: 'P5W'
    monthlyRetention: 'P3M'
  }
  dependsOn: [
    transparent_data_encryption
  ]
}

resource backup_short_term 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2021-11-01' = {
  name: 'default'
  parent: database
  properties: {
    retentionDays: 31
  }
  dependsOn: [
    backup_long_term
  ]
}

// Resource Lock
// --- [Outputs] ---
output databaseName string = databaseName
