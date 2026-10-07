param name string
param location string
param tags object
param planId string
param linuxFxVersion string
param httpsOnly bool = true
param alwaysOn bool = true
param healthCheckPath string = ''
param startupCommand string = ''
param appSettings object = {}
param enableSystemIdentity bool = false

resource site 'Microsoft.Web/sites@2023-12-01' = {
  name: name
  location: location
  tags: tags
  kind: 'app,linux'
  identity: enableSystemIdentity ? { type: 'SystemAssigned' } : null
  properties: {
    serverFarmId: planId
    httpsOnly: httpsOnly
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      alwaysOn: alwaysOn
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      http20Enabled: true
      healthCheckPath: empty(healthCheckPath) ? null : healthCheckPath
      appCommandLine: empty(startupCommand) ? null : startupCommand
      appSettings: [for s in items(appSettings): {
        name: s.key
        value: string(s.value)
      }]
    }
  }
}

output defaultHostName string = site.properties.defaultHostName
output principalId string = enableSystemIdentity ? site.identity.principalId : ''