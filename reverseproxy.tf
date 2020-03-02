resource "azurerm_public_ip" "jumpbox" {
 name                         = "jumpbox-public-ip"
 location                     = "West Europe"
 resource_group_name          = "${azurerm_resource_group.test.name}"
 allocation_method 	      = "Static"
 domain_name_label            = "haithemproxy-ssh"
}

resource "azurerm_network_interface" "jumpbox" {
 name                = "jumpbox-nic"
 location            = "West Europe"
 resource_group_name = "${azurerm_resource_group.test.name}"

 ip_configuration {
   name                          = "IPConfiguration"
   subnet_id                     = "${azurerm_subnet.test3.id}" 
   private_ip_address_allocation = "dynamic"
   public_ip_address_id          = "${azurerm_public_ip.jumpbox.id}"
 }
}

resource "azurerm_virtual_machine" "jumpbox" {
 name                  = "jumpbox"
 location              = "West Europe"
 resource_group_name   = "${azurerm_resource_group.test.name}"
 network_interface_ids = ["${azurerm_network_interface.jumpbox.id}"]
 vm_size               = "Standard_B1s"

 storage_image_reference {
   publisher = "OpenLogic"
    offer     = "Centos"
    sku       = "7.6"
    version   = "latest"
 }

 storage_os_disk {
   name              = "jumpbox-osdisk"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 os_profile {
   computer_name  = "jumpbox"
   admin_username = "HaithemBK0"
 }

 os_profile_linux_config {
   disable_password_authentication = true
   ssh_keys {
      path = "/home/HaithemBK0/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLwijtRr1TVwjELxB2CkqONbUYCO0ZqQd/RTRTimwDTNGj3SemLFjhugPcBt2bC0IPx5NVDuEAl2TSu4D7cblLFH/utsIyxe6KZgR3QhvYjD1BZ7QIGLsmSVmxk27iFyuQfvDPVoWuIW/5X3X9dbXxm9qP5Jcwd4GdJofHXdO/WiunRANcrguDGDSoE3u3hQSJzPYmTWUFMsg9oSTjCIi6x0GE35Ikv/d140ImBzFzdZDK/gNWzN+hOvOjjypLZ2HNCkZDS7Qx5mSAoHj2GABEUMG3wh1qAhKCwJPmVurgym6G7ePVgoNtFmJJnyIfSJtgfdptl9c4TeHe0XzqW6bV vagrant@localhost.localdomain"
    }
 }

}
