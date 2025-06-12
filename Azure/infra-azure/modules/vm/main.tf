############################
# Virtual machine -> Jenkins
############################

resource "azurerm_linux_virtual_machine" "Jenkins" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.size # "Standard_B1s"  # Gratis
  admin_username      = var.admin_username

  network_interface_ids = [
    var.nic_id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.public_key_path)
  }

  os_disk {
    name                 = "${var.name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  tags = {
    Name = var.name
  }
}
