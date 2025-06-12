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
  name     = "jenkins-rules"
  location = var.location
}

# Virtual Network and Subnet
module "network" {
  source              = "./modules/network"
  location            = var.location
  resource_group_name = azurerm_resource_group.jenkins.name
}

# Public IP
module "public_ip" {
  source              = "./modules/public_ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.jenkins.name
}

# Network Security Group
module "network_security" {
  source              = "./modules/network_security"
  nsg_name            = var.nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.jenkins.name
}

# Network Interface
module "network_interface" {
  source              = "./modules/network_interface"
  nic_name            = "jenkins-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.jenkins.name
  subnet_id           = module.network.subnet_id
  public_ip_id        = module.public_ip.public_ip_id
  nsg_id              = module.network_security.nsg_id
}

# Virtual Machine
module "Jenkins" {
  source              = "./modules/vm"
  name                = var.name
  location            = var.location
  resource_group_name = azurerm_resource_group.jenkins.name
  admin_username      = var.admin_username
  public_key_path     = var.public_key_path
  nic_id              = module.network_interface.nic_id
}








