terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.116.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true

}
module "resourcegroup" {
  source   = "./modules/resourcegroup"
  name     = var.name
  location = var.location
}

module "networking" {
  source         = "./modules/networking"
  location       = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  vnetcidr       = var.vnetcidr
  websubnetcidr  = var.websubnetcidr
  appsubnetcidr  = var.appsubnetcidr
  dbsubnetcidr   = var.dbsubnetcidr
}

module "securitygroup" {
  source         = "./modules/securitygroup"
  location       = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  web_subnet_id  = module.networking.websubnet_id
  app_subnet_id  = module.networking.appsubnet_id
  db_subnet_id   = module.networking.dbsubnet_id
}

module "compute" {
  source           = "./modules/compute"
  location         = module.resourcegroup.location_id
  resource_group   = module.resourcegroup.resource_group_name
  web_subnet_id    = module.networking.websubnet_id
  app_subnet_id    = module.networking.appsubnet_id
  web_host_name    = var.web_host_name
  web_username     = var.web_username
  web_os_password  = var.web_os_password
  app_host_name    = var.app_host_name
  app_username     = var.app_username
  app_os_password  = var.app_os_password
  web_public_ip_id = azurerm_public_ip.web-public-ip.id
  app_public_ip_id = azurerm_public_ip.app-public-ip.id
}

module "database" {
  source                    = "./modules/database"
  location                  = module.resourcegroup.location_id
  resource_group            = module.resourcegroup.resource_group_name
  primary_database          = var.primary_database
  primary_database_version  = var.primary_database_version
  primary_database_admin    = var.primary_database_admin
  primary_database_password = var.primary_database_password
}
#imported resources(can use as is too, preferred to move to compute/main.tf): 
resource "azurerm_public_ip" "app-public-ip" {
  name                = "pip-vnet01-centralindia-app-subnet"
  location            = var.location
  resource_group_name = module.resourcegroup.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
resource "azurerm_public_ip" "web-public-ip" {
  name                = "pip-vnet01-centralindia-web-subnet"
  location            = var.location
  resource_group_name = module.resourcegroup.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}