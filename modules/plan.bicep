param name string
param location string
param tags object
param sku string
param capacity int = 1
@allowed(['linux', 'windows'])
param kind string = 'linux'

resource plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: name
  location: location
  tags: tags
  kind: kind
  sku: {
    name: sku
    capacity: capacity
  }
  properties: {
    reserved: kind == 'linux'
  }
}

output id string = plan.id