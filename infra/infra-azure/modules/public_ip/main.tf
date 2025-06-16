#############################################
# Public IP -> Jenkins Master / Jenkins Slave
#############################################

resource "azurerm_public_ip" "public_ip" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
}