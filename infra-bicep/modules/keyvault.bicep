metadata majorVersion = '3'
metadata minorVersion = '0'

@description('[OPTIONAL]: Secret value to be added to the key vault (Default: "")')
param webAppSecretValue string = ''

@description('[REQUIRED]: The key vault name (Maximum: 24 chars)')
@maxLength(24)
param keyVaultName string

@description('[OPTIONAL]: The resource id of the log analytics workspace where the key vault diagnostic settings will be sent to (Default: "")')
param logAnalyticsWorkspaceId string = ''

@description('[OPTIONAL]: The sku of the key vault (Default: "premium")')
@allowed([
  'premium'
  'standard'
])
param sku string = 'premium'

@description('[OPTIONAL]: Whether or not public endpoint access is allowed for this key vault (Default: "Disabled")')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

@description('[OPTIONAL]: The location for all the resources in the key vault module (Default: resourceGroup().location)')
param location string = resourceGroup().location

type privateEndpointType = {
  @description('[REQUIRED]: Name of the private endpoint')
  name: string
  @description('[OPTIONAL]: Resource id of the zone (Default: null)')
  zoneId: string?
  @description('[REQUIRED]: Resource id of the subnet')
  subnetId: string
}[]
@description('[OPTIONAL]: An array of objects of private endpoints (Default: [])')
param privateEndpoints privateEndpointType = []

@description('[OPTIONAL]: An object of key-value pairs of tags (Default: {}) ')
param tags object = {}

@description('[OPTIONAL]: Specifies the number of days to keep the audit logs in the storage account (Default: 90, Accepted: value between 7 - 90 days)')
@minValue(7)
@maxValue(90)
param retentionDays int = 90

@description('[OPTIONAL]: Boolean that controls whether the key vault resource should be locked or not (Default: False)')
param lockResources bool = false

@description('[OPTIONAL]: Property to specify whether azure disk encryption is permitted to retrieve secrets from the vault and unwrap keys (Default: True)')
param enableDiskEncryption bool = true

@description('[OPTIONAL]: Property to specify whether the soft delete functionality is enabled for this key vault. Once set to true, it cannot be reverted to false (Default: True) ')
param enableSoftDelete bool = true

@description('[OPTIONAL]: Property to specify whether protection against purge is enabled. True activates protection against purge for the vault and its content - only the key vault service may initiate a hard, irrecoverable deletion. The setting is effective only if soft delete is also enabled. Enabling this functionality is irreversible - that is, the property does not accept false as its value. (Default: True)')
param enablePurgeProtection bool = true

@description('[OPTIONAL]: An array of 0 to 1024 identities that have access to the key vault. Tenant ID of array items must contain the key vaults tenant ID. Access policies are required, unless createMode is set to recover. (Default: [])')
type accessPoliciesType = {
  @description('[REQUIRED]: The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies.')
  objectId: string
  permissions: {
    @description('[OPTIONAL]: Permissions to certificates (Default: [])')
    certificates: [

        | 'all'
        | 'backup'
        | 'create'
        | 'delete'
        | 'deleteissuers'
        | 'get'
        | 'getissuers'
        | 'import'
        | 'list'
        | 'listissuers'
        | 'managecontacts'
        | 'manageissuers'
        | 'purge'
        | 'recover'
        | 'restore'
        | 'setissuers'
        | 'update'
    ]?
    @description('[OPTIONAL]: Permissions to keys (Default: [])')
    keys: [

        | 'all'
        | 'backup'
        | 'create'
        | 'decrypt'
        | 'delete'
        | 'encrypt'
        | 'get'
        | 'getrotationpolicy'
        | 'import'
        | 'list'
        | 'purge'
        | 'recover'
        | 'release'
        | 'restore'
        | 'rotate'
        | 'setrotationpolicy'
        | 'sign'
        | 'unwrapKey'
        | 'update'
        | 'verify'
        | 'wrapKey'
    ]?
    @description('[OPTIONAL]: Permissions to secrets (Default: [])')
    secrets: ['all' | 'backup' | 'delete' | 'get' | 'list' | 'purge' | 'recover' | 'restore' | 'set']?
    @description('[OPTIONAL]: Permissions to storage (Default: [])')
    storage: [

        | 'all'
        | 'backup'
        | 'delete'
        | 'deletesas'
        | 'get'
        | 'getsas'
        | 'list'
        | 'listsas'
        | 'purge'
        | 'recover'
        | 'regeneratekey'
        | 'restore'
        | 'set'
        | 'setsas'
        | 'update'
    ]?
  }
  @description('[REQUIRED]: The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault')
  tenantId: string
}[]

param accessPolicies accessPoliciesType = []

@description('[OPTIONAL]: Property to specify whether azure virtual machines are permitted to retrieve certificates stored as secrets from the key vault (Default: False)')
param enabledForDeployment bool = false

@description('[OPTIONAL]: Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored. Defaults to true')
param enableRbacAuthorization bool = true

type metricsType = {
  @description('[REQUIRED]: Enable metric AllMetrics to log')
  AllMetrics: bool
}
@description('[OPTIONAL]: The diagnostic settings metrics for key vault (Default: AllMetrics: True)')
param metrics metricsType = {
  AllMetrics: true
}

type logsType = {
  @description('[REQUIRED]: Enable log AuditEvent to log')
  AuditEvent: bool
  @description('[REQUIRED]: Enable log AzurePolicyEvaluationDetails to log')
  AzurePolicyEvaluationDetails: bool
}

@description('[OPTIONAL]: The diagnostic settings logs for key vault (Default: AuditEvent: True, AzurePolicyEvaluationDetails: True)')
param logs logsType = {
  AuditEvent: true
  AzurePolicyEvaluationDetails: true
}

@description('[OPTIONAL]: Custom name for diagnostic settings of key vault (Default: keyVaultName-diagnosticSetting)')
param diagnosticSettingName string = '${keyVaultName}-diagnosticSetting'

type networkAclType = {
  @description('[REQUIRED]: Specifies whether traffic for logging/metrics/azureservices is bypassed. Combination is also possible')
  bypass: string
  @description('[REQUIRED]: The virtual network rules')
  virtualNetworkRules: virtualNetworkRulesType
  @description('[REQUIRED]: The ip acl rules')
  ipRules: ipRulesType
  @description('[REQUIRED]: Specifies the default action of allow or deny when no other rules match')
  defaultAction: 'Allow' | 'Deny'
}

type ipRulesType = {
  @description('[REQUIRED]: Value of the ip acl rule')
  value: string
  @description('[REQUIRED]: Action of the ip acl rule')
  action: 'Allow' | 'Deny'
}[]

type virtualNetworkRulesType = {
  @description('[REQUIRED]: Id of the virtual network rule')
  id: string
  @description('[REQUIRED]: Create firewall rule before the virtual network has vnet service endpoint enabled')
  ignoreMissingVnetServiceEndpoint: true | false
}[]

@description('[OPTIONAL]: The network access control object (Default: { bypass: "AzureServices", ipRules: [], virtualNetworkRules: [], defaultAction: "Allow" })')
param networkAcls networkAclType = {
  bypass: 'AzureServices'
  ipRules: []
  virtualNetworkRules: []
  defaultAction: 'Allow'
}

type rbacType = {
  @description('[REQUIRED]: The principal id')
  principalId: string
  @description('[REQUIRED]: The principal type (Allowed: "Device", "ForeignGroup", "Group", "ServicePrincipal", "User")')
  principalType: 'Device' | 'ForeignGroup' | 'Group' | 'ServicePrincipal' | 'User'
  @description('[REQUIRED]: The role definition id. Include the function resourceId(): resourceId(\'Microsoft.Authorization/roleDefinitions\',\'roleDefinitionId\')')
  roleDefinitionId: string
}[]
@description('[OPTIONAL]: An array of objects of RBAC to set on key vault scope (Default: [])')
param roleAssignments rbacType = []

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: sku
    }
    tenantId: subscription().tenantId
    enabledForDeployment: enabledForDeployment
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: enableDiskEncryption
    enableSoftDelete: enableSoftDelete
    enablePurgeProtection: enablePurgeProtection ? enablePurgeProtection : null
    softDeleteRetentionInDays: retentionDays
    accessPolicies: accessPolicies
    publicNetworkAccess: publicNetworkAccess
    enableRbacAuthorization: enableRbacAuthorization
    networkAcls: networkAcls
  }
  tags: tags
}

resource roleAssigmentKeyVault 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleAssigment in roleAssignments: {
    name: guid(keyVault.name, roleAssigment.principalId, roleAssigment.roleDefinitionId)
    scope: keyVault
    properties: {
      principalId: roleAssigment.principalId
      principalType: roleAssigment.principalType
      roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleAssigment.roleDefinitionId)
    }
  }
]

resource keyVaultLock 'Microsoft.Authorization/locks@2020-05-01' = if (lockResources) {
  name: '${keyVault.name}-Lock'
  scope: keyVault
  properties: {
    level: 'CanNotDelete'
    notes: 'Locked by BicepTemplate'
  }
}

resource privateEndpointKeyvault 'Microsoft.Network/privateEndpoints@2023-06-01' = [
  for (endpoint, iCounter) in privateEndpoints: {
    name: endpoint.name
    location: location
    tags: tags
    properties: {
      customNetworkInterfaceName: '${endpoint.name}-nic'
      privateLinkServiceConnections: [
        {
          name: '${endpoint.name}-plsc'
          properties: {
            groupIds: [
              'vault'
            ]
            privateLinkServiceId: keyVault.id
          }
        }
      ]
      subnet: {
        id: endpoint.subnetId
      }
    }
  }
]

resource privateEndpointDnsIntegration 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-03-01' = [
  for (endpoint, iCounter) in privateEndpoints: if (contains(endpoint, 'zoneId')) {
    name: '${endpoint.name}-DnsIntegration'
    parent: privateEndpointKeyvault[iCounter]
    properties: {
      privateDnsZoneConfigs: [
        {
          name: 'privatelink.vaultcore.azure.net'
          properties: {
            privateDnsZoneId: endpoint.zoneId
          }
        }
      ]
    }
  }
]

resource diagnosticSettingKeyVault 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (logAnalyticsWorkspaceId != '') {
  name: diagnosticSettingName
  scope: keyVault
  properties: {
    logs: [
      {
        category: 'AuditEvent'
        enabled: logs.AuditEvent
      }
      {
        category: 'AzurePolicyEvaluationDetails'
        enabled: logs.AzurePolicyEvaluationDetails
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: metrics.AllMetrics
      }
    ]
    workspaceId: logAnalyticsWorkspaceId
  }
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-04-01-preview' = if (webAppSecretValue != '') {
  name: 'test-secret'
  parent: keyVault
  properties: {
    value: webAppSecretValue
  }
}

output keyVault object = keyVault
output id string = keyVault.id
output name string = keyVault.name
