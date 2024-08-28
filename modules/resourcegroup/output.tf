output "resource_group_name" {
    value = data.azurerm_resource_group.azure-stack-rs.name
    description = "Name of the resource group."
}

output "location_id" {
    value = data.azurerm_resource_group.azure-stack-rs.location
    description = "Location id of the resource group"
}