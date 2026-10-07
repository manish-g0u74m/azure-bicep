targetScope = 'subscription'

@description('Name of the resource group. It will be created if it does not exist.')
param resourceGroupName string

@description('Azure region')
param location string

@description('Tags applied to all resources.')
param tags object = {}

@description('List of App Service plans: { name, sku, capacity?, kind? }.')
param appServicePlans array

@description('List of web apps: { name, planName, linuxFxVersion, ... }. Details are defined in the parameter files.')
param webApps array

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

module appServices 'modules/appservices.bicep' = {
  name: 'appservices-${uniqueString(rg.id)}'
  scope: rg
  params: {
    location: location
    tags: tags
    appServicePlans: appServicePlans
    webApps: webApps
  }
}

output webAppHostNames array = appServices.outputs.webAppHostNames
