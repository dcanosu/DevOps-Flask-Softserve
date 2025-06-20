terraform {
  required_version = ">= 1.3.0" # Ensures compatibility with Terraform v1.3 or higher

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create the resource group
resource "azurerm_resource_group" "jenkins" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network and Subnet
module "network" {
  source              = "./modules/network"
  location            = var.location
  resource_group_name = azurerm_resource_group.jenkins.name
}

# Public IP
module "jenkins_public_ip" {
  source              = "./modules/public_ip"
  name                = var.master_public_ip_name
  location            = var.location
  resource_group_name = azurerm_resource_group.jenkins.name
}

module "jenkins_slave_public_ip" {
  source              = "./modules/public_ip"
  name                = var.slave_public_ip_name
  location            = var.location
  resource_group_name = azurerm_resource_group.jenkins.name
}

# Network Security Group
module "nsg" {
  source              = "./modules/network_security"
  nsg_name            = var.nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.jenkins.name
}

# Network Interface
module "network_interface" {
  source                    = "./modules/network_interface"
  name                      = var.master_network_interface_name
  location                  = var.location
  resource_group_name       = azurerm_resource_group.jenkins.name
  subnet_id                 = module.network.subnet_id
  public_ip_id              = module.jenkins_public_ip.public_ip_id
  network_security_group_id = module.nsg.nsg_id
}

module "network_interface_slave" {
  source                    = "./modules/network_interface"
  name                      = var.slave_network_interface_name
  location                  = var.location
  resource_group_name       = azurerm_resource_group.jenkins.name
  subnet_id                 = module.network.subnet_id
  public_ip_id              = module.jenkins_slave_public_ip.public_ip_id
  network_security_group_id = module.nsg.nsg_id
}

# Virtual Machine
module "Jenkins" {
  source = "./modules/vm"
  name                = var.master_vm_name
  location            = var.location
  resource_group_name = azurerm_resource_group.jenkins.name
  admin_username      = var.admin_username
  public_key_path     = var.public_key_path
  nic_id              = module.network_interface.nic_id
  role                = var.role_master
}

module "Jenkins_slave" {
  source = "./modules/vm"
  name                = var.slave_vm_name
  location            = var.location
  resource_group_name = azurerm_resource_group.jenkins.name
  admin_username      = var.admin_vm_slave
  public_key_path     = var.public_key_path
  nic_id              = module.network_interface_slave.nic_id
  role                = var.role_slave
}