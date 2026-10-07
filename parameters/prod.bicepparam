using '../main.bicep'

param resourceGroupName = 'rg-myproject-prod'
param location = 'centralindia'

param tags = {
  environment: 'prod'
  owner: 'team-name'
}

param appServicePlans = [
  {
    name: 'asp-myproject-prod'
    sku: 'P1v3'
    capacity: 2
  }
]

param webApps = [
  {
    name: 'myproject-frontend-prod-001'
    planName: 'asp-myproject-prod'
    linuxFxVersion: 'NODE|20-lts'
    healthCheckPath: '/health'
    appSettings: {
      NODE_ENV: 'production'
    }
  }
  {
    name: 'myproject-api-prod-001'
    planName: 'asp-myproject-prod'
    linuxFxVersion: 'DOTNETCORE|8.0'
    enableSystemIdentity: true
  }
]