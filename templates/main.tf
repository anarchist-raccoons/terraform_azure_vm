# with AZURE
module "azure_vm" {
  source =  "git::https://github.com/anarchist-raccoons/terraform_azure_vm.git?ref=master"
  
  subscription_id = "${var.subscription_id}"
  tenant_id = "${var.tenant_id}"
  owner = "${var.owner}"
  name = "${var.name}"
  public_key = "${var.public_key}"
  developer_access = "${var.developer_access}"
  user_access = "${var.user_access}"
  
  resource_group_name = "${var.resource_group_name}"
  location = "${var.location}"
  account_tier = "${var.account_tier}"
  environment = "${var.environment}"
  namespace-org = "${var.namespace-org}"
  org = "${var.org}"
  service = "${var.service}"
  product = "${var.product}"
  team = "${var.team}"
  vm_size ="${var.vm_size}"
  
  # server_user
  
  # Default image is CentOS
  # vm_image ={
  #   publisher = "Canonical"
  #   offer     = "UbuntuServer"
  #   sku       = "16.04-LTS"
  #   version   = "latest"
  # }
}

# Use a separate module to add a dns A record
module "terraform_azure_dns_arecord_hyrax" {
  source = "git::https://github.com/anarchist-raccoons/terraform_azure_dns_arecord.git?ref=master"
  
  # Required - add to terraform.tvars
  subscription_id = "${var.subscription_id}"
  tenant_id = "${var.tenant_id}"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  owner = "${var.owner}"
  name = "${var.name}"
  
  zone_name = "${var.zone_name}"
  zone_resource_group = "${var.zone_resource_group}"
  record = "${module.azure_vm.public_ip}"
  
  # Labels
  environment = "${var.environment}"
  namespace-org = "${var.namespace-org}"
  org = "${var.org}"
  service = "${var.service}"
  product = "${var.product}"
  team = "${var.team}"
}

