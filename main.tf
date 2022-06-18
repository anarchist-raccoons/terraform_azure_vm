# https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-create-complete-vm
# For consistent naming https://registry.terraform.io/modules/devops-workflow/label/local

provider "azurerm" { 
  subscription_id = var.subscription_id
  # client_id = var.client_id
  # client_secret = var.client_secret
  tenant_id = var.tenant_id
}
module "labels" {
  source = "devops-workflow/label/local"
  version = "0.2.1"

  # Required
  environment = var.environment
  name = var.name
  # Optional
  namespace-org = var.namespace-org
  organization = var.org
  delimiter = "-"
  owner = var.owner
  team = var.team
  tags {
    Name = module.labels.id
  }
}

# Resource Groups
resource "azurerm_resource_group" "default" {
  name = module.labels.id
  location = var.location

  tags = module.labels.tags
}

resource "azurerm_virtual_network" "network" {
    name = "${module.labels.id}-vnet"
    address_space = ["10.0.0.0/16"]
    location = var.location
    resource_group_name = azurerm_resource_group.default.name

    tags = module.labels.tags
}

resource "azurerm_subnet" "subnet" {
    name = "${module.labels.id}-subnet"
    resource_group_name = azurerm_resource_group.default.name
    virtual_network_name = azurerm_virtual_network.network.name
    address_prefix = "10.0.2.0/24"
}

resource "azurerm_public_ip" "publicip" {
  name = "${module.labels.id}-publicip"
  location = var.location
  resource_group_name = azurerm_resource_group.default.name
  allocation_method = "Static"

  tags = module.labels.tags
}

resource "azurerm_network_security_group" "security_groups" {
    name = module.labels.id
    location = var.location
    resource_group_name = azurerm_resource_group.default.name

    security_rule {
        name = "allow-all-developer"
        priority = 1001
        direction = "Inbound"
        access = "Allow"
        protocol = "TCP"
        source_port_range = "*"
        destination_port_range = "*"
        source_address_prefixes = var.developer_access
        destination_address_prefix = "*"
    }
    security_rule {
        name = "allow-all-users"
        priority = 1002
        direction = "Inbound"
        access = "Allow"
        protocol = "TCP"
        source_port_range = "80"
        destination_port_range = "80"
        source_address_prefixes = var.user_access
        destination_address_prefix = "*"
    }

    tags = module.labels.tags
}

resource "azurerm_network_interface" "nic" {
    name = "${module.labels.id}-nic"
    location = var.location
    resource_group_name = azurerm_resource_group.default.name
    network_security_group_id = azurerm_network_security_group.security_groups.id
    

    ip_configuration {
        name = "${module.labels.id}-ipconf"
        subnet_id = azurerm_subnet.subnet.id
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = azurerm_public_ip.publicip.id
    }

    tags = module.labels.tags
}

resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.default.name
    }

    byte_length = 8
}

resource "azurerm_storage_account" "storageaccount" {
    name = "diag${random_id.randomId.hex}"
    resource_group_name = azurerm_resource_group.default.name
    location = var.location
    account_replication_type = "LRS"
    account_tier = var.account_tier

    tags = module.labels.tags
}

resource "azurerm_virtual_machine" "vm" {
    # Because when we run the deploy module, we need the public ip
    depends_on = ["azurerm_network_interface.nic"]

    name = "${module.labels.id}-vm"
    location = var.location
    resource_group_name = azurerm_resource_group.default.name
    network_interface_ids = [azurerm_network_interface.nic.id]
    vm_size = var.vm_size

    storage_os_disk {
        name = module.labels.id
        caching = "ReadWrite"
        create_option = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    # https://azuremarketplace.microsoft.com/en-us/marketplace/apps/RogueWave.CentOSbased75?tab=Overview
    storage_image_reference = {
      publisher = var.vm_image["publisher"]
      offer = var.vm_image["offer"]
      sku = var.vm_image["sku"]
      version = var.vm_image["version"]
    }

    os_profile {
        computer_name = "${module.labels.id}-vm"
        admin_username = var.server_user
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path = "/home/${var.server_user}/.ssh/authorized_keys"
            key_data = var.public_key
        }
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = azurerm_storage_account.storageaccount.primary_blob_endpoint
    }

    tags = module.labels.tags
}




