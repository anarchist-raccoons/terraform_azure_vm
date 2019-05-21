# terraform_azure_vm

Module for deploying an Azure Centos VM

## Using the module

Please refer to the files in the templates directory for sample deployment files.

1. Download the files in the templates directory (templates/main.tf, templates/variables.tf and templates/terraform.tfvars.template)
2. Copy terraform.tfvars.template to terraform.tfvars and fill out the variables listed
3. Run `terraform init` to install the modules
4. Run `terraform plan` (or `terraform plan -out myplan.tfplan`) 
5. Run `terraform apply` (or `terraform apply"myplan.tfplan"`) to deploy to Azure

Note: these files also deploy a DNS Zone A Record. If you do not have one available, simply remove this section from the main.tf file.