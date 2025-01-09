using 'main.bicep'

param environmentName = 'bicep'
param lockResources = false
param starterName = ''

param githubRunNumber = readEnvironmentVariable('GITHUB_RUN_NUMBER')
param sharedResourceGroupName = readEnvironmentVariable('AZURE_RESOURCE_GROUP_SHARED')
param acrName = readEnvironmentVariable('ACR_NAME')
param acrUsername = readEnvironmentVariable('ACR_USERNAME')
param acrPassword = readEnvironmentVariable('ACR_PASSWORD')
