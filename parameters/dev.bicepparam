using '../main.bicep'

param resourceGroupName = 'rg-myproject-dev'
param location = 'centralindia'

param tags = {
  environment: 'dev'
  owner: 'team-name'
}

// ---- App Service plans ----
param appServicePlans = [
  {
    name: 'asp-myproject-dev'
    sku: 'B1'
    capacity: 1
  }
]

// ---- Web apps: add a block here to create another app. ----
// NOTE: The name must be globally unique (<name>.azurewebsites.net).
param webApps = [
  {
    name: 'myproject-frontend-dev-001'
    planName: 'asp-myproject-dev'
    linuxFxVersion: 'NODE|20-lts'
    healthCheckPath: '/health'
    appSettings: {
      API_URL: 'https://myproject-api-dev-001.azurewebsites.net'
      NODE_ENV: 'development'
    }
  }
  {
    name: 'myproject-api-dev-001'
    planName: 'asp-myproject-dev'
    linuxFxVersion: 'DOTNETCORE|8.0'
    enableSystemIdentity: true
    appSettings: {
      ASPNETCORE_ENVIRONMENT: 'Development'
    }
  }
  {
    name: 'myproject-admin-dev-001'
    planName: 'asp-myproject-dev'
    linuxFxVersion: 'PYTHON|3.12'
    startupCommand: 'gunicorn app:app'
  }
]