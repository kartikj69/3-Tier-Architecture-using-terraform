
resource "azurerm_availability_set" "web_availabilty_set" {
  name                = "web_availabilty_set"
  location            = var.location
  resource_group_name = var.resource_group
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
resource "azurerm_public_ip" "web-public-ip-linux" {
  name = "web-pip-linux"
  location = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
resource "azurerm_network_interface" "web-net-interface" {
    name = "web-network"
    resource_group_name = var.resource_group
    location = var.location

    ip_configuration{
        name = "web-webserver"
        subnet_id = var.web_subnet_id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = var.web_public_ip_id
    }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
resource "azurerm_network_interface" "web-net-interface-linux" {
    name = "web-network-linux"
    resource_group_name = var.resource_group
    location = var.location

    ip_configuration{
        name = "web-webserver-linux"
        subnet_id = var.web_subnet_id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.web-public-ip-linux.id
    }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
resource "azurerm_linux_virtual_machine" "web-vm-linux" {
  name = "web-vm-linux"
  resource_group_name = var.resource_group
  location = var.location
  size = "Standard_DS1_v2"
  network_interface_ids = [ azurerm_network_interface.web-net-interface-linux.id ]
  availability_set_id = azurerm_availability_set.web_availabilty_set.id
  admin_username = var.web_username
  admin_password = var.web_os_password
  disable_password_authentication = false
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
resource "azurerm_windows_virtual_machine" "web-vm2" {
  name = "web-vm2"
  resource_group_name = var.resource_group
  location = var.location
  size = "Standard_DS1_v2"
  # delete_os_disk_on_termination = true
  admin_username = var.web_username
  admin_password = var.web_os_password
  availability_set_id = azurerm_availability_set.web_availabilty_set.id
  network_interface_ids = [ azurerm_network_interface.web-net-interface.id ]
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_availability_set" "app_availabilty_set" {
  name                = "app_availabilty_set"
  location            = var.location
  resource_group_name = var.resource_group
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_public_ip" "app-public-ip-linux" {
  name = "app-pip-linux"
  location = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
resource "azurerm_network_interface" "app-net-interface" {
    name = "app-network"
    resource_group_name = var.resource_group
    location = var.location
    ip_configuration{
        name = "app-webserver"
        subnet_id = var.app_subnet_id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = var.app_public_ip_id
    }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
resource "azurerm_network_interface" "app-net-interface-linux" {
  name = "app-network-linux"
  resource_group_name = var.resource_group
  location = var.location
  
  ip_configuration{
      name = "app-webserver-linux"
      subnet_id = var.app_subnet_id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.app-public-ip-linux.id
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  } 
}
resource "azurerm_linux_virtual_machine" "app-vm-linux" {
  name = "app-vm-linux"
  resource_group_name = var.resource_group
  location = var.location
  size = "Standard_DS1_v2"
  network_interface_ids = [ azurerm_network_interface.app-net-interface-linux.id ]
  availability_set_id = azurerm_availability_set.app_availabilty_set.id
  admin_username = var.app_username
  admin_password = var.app_os_password
  disable_password_authentication = false
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
resource "azurerm_windows_virtual_machine" "app-vm2" {
  name = "app-vm2"
  resource_group_name = var.resource_group
  location = var.location
  size = "Standard_DS1_v2"
  # delete_os_disk_on_termination = true
  admin_username = var.app_username
  admin_password = var.app_os_password
  availability_set_id = azurerm_availability_set.app_availabilty_set.id
  network_interface_ids = [ azurerm_network_interface.app-net-interface.id ]
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
