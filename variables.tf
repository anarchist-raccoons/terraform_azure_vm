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
  description = "VM Size, see https://docs.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-manage-vm"
  default = "Standard_F2s_v2"
}

variable "owner" { 
  description = "Email address of the instance owner."
  default = "" 
}

variable "name" {
  description = "Short name for use across all AWS resouves."
  default = "terraform"
}

variable "environment" { 
  description = "Valid values are 'dev', 'uat', 'prod'."
  default = "dev"
}

variable "namespace-org" {
  description = "Use true to include namesapce in the label (namespace-stage/environment-name)."
  default = true
}

variable "org" {
  description = "Organisation name."
  default = "leaf"
}

variable "service" {
  description = "Service name. Optional."
  default = ""
}

variable "product" {
  description = "Produt name. Optional."
  default = ""
}

variable "team" {
  description = "Team name."
  default = "research-technologies"
}
variable "developer_access" {
  description = "List of CIDR blocks for full (developer) access. Supply in terraform.tvars"
  type = "list"
  default = []
}