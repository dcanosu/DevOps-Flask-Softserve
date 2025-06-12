resource "azurerm_public_ip" "public_ip" {
  name                = "jenkins-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}
