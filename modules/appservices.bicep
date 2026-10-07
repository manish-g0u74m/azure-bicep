targetScope = 'resourceGroup'

param location string
param tags object
param appServicePlans array
param webApps array

// Create one module for each App Service plan.
module plans 'plan.bicep' = [for plan in appServicePlans: {
  name: 'plan-${plan.name}'
  params: {
    name: plan.name
    location: location
    tags: tags
    sku: plan.sku
    capacity: plan.?capacity ?? 1
    kind: plan.?kind ?? 'linux'
  }
}]

// Create one module for each web app.
module apps 'webapp.bicep' = [for app in webApps: {
  name: 'app-${app.name}'
  params: {
    name: app.name
    location: location
    tags: tags
    planId: resourceId('Microsoft.Web/serverfarms', app.planName)
    linuxFxVersion: app.linuxFxVersion
    httpsOnly: app.?httpsOnly ?? true
    alwaysOn: app.?alwaysOn ?? true
    healthCheckPath: app.?healthCheckPath ?? ''
    startupCommand: app.?startupCommand ?? ''
    appSettings: app.?appSettings ?? {}
    enableSystemIdentity: app.?enableSystemIdentity ?? false
  }
  dependsOn: [
    plans
  ]
}]

output webAppHostNames array = [for (app, i) in webApps: apps[i].outputs.defaultHostName]