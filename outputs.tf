output "public_ip" {
  value = "${azurerm_public_ip.publicip.ip_address}"
}

output "vm_id" {
  value = "${azurerm_virtual_machine.vm.id}"
}
