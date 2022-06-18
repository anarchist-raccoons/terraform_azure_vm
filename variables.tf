variable "subscription_id" {
    description = "Azure subscription ID"
}
variable "client_id" {
    description = "Azure client ID. Optional."
    default = ""
}
variable "client_secret" {
    description = "Azure client secret. Optional."
    default = ""
}
variable "tenant_id" {
    description = "Azure tenant ID."
}
variable "public_key" {
  description = "Provide a valid public SSH key"
  default = ""
}
variable "resource_group_name" {
  description = "Name of the azure resource group."
}

variable "location" {
  description = "Location of the azure resource group. Default is London."
  default = "uksouth"
}

# https://azure.microsoft.com/en-gb/pricing/details/app-service/windows/
variable "account_tier" {
  description = "Account Tier"
  default = "Standard"
}
# az vm list-skus --output table | grep uksouth
variable "vm_size" {
  description = "VM Size, see https://docs.microsoft.com/en-us/azure/virtual-machines/linux/sizes-general"
  default = "Standard_B1s"
}

variable "vm_image" {
  description = "Image, see https://azuremarketplace.microsoft.com/en-us/marketplace/apps/RogueWave.CentOS76?tab=Overview"
  type = "map"
  default = {
      publisher = "OpenLogic"
      offer = "CentOS"
      sku = "7.6"
      version = "latest"
    }
}

variable "developer_access" {
  description = "List of CIDR blocks for full (developer) access. Supply in terraform.tvars"
  type = list
  default = []
}

variable "user_access" {
  description = "List of CIDR blocks for user access (port 80). Supply in terraform.tvars"
  type = list
  default = []
}

variable "server_user" {
  description= "User for the server, normally azureuser"
  default = "azureuser"
}
