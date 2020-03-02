resource "azurerm_network_security_group" "mySecnsg" {
  name                = "nsgProjet2"
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.test.name}"

 security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "inbound"
    access                     = "allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

 security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


resource "azurerm_network_interface" "mySecNIC" {
  name                = "nameNIC2"
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.test.name}"
  network_security_group_id = "${azurerm_network_security_group.mySecnsg.id}"

  ip_configuration {
    name                          = "nameNICConfig2"
    subnet_id                     = "${azurerm_subnet.test2.id}"
    private_ip_address_allocation = "Dynamic"
#    public_ip_address_id          = "${azurerm_public_ip.mySecPubIp.id}"
  }
}

resource "azurerm_virtual_machine" "mySecVm" {
  name                  = "vm2"
  location              = "West Europe"
  resource_group_name   = "${azurerm_resource_group.test.name}"
  network_interface_ids = ["${azurerm_network_interface.mySecNIC.id}"]
  vm_size               = "Standard_B1s"

  storage_image_reference {
    publisher = "OpenLogic"                                                                                              offer     = "Centos"                                                                                                 sku       = "7.6"                                                                                                    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "HaithemAzure"
    admin_username = "HaithemBK2"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/HaithemBK2/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLwijtRr1TVwjELxB2CkqONbUYCO0ZqQd/RTRTimwDTNGj3SemLFjhugPcBt2bC0IPx5NVDuEAl2TSu4D7cblLFH/utsIyxe6KZgR3QhvYjD1BZ7QIGLsmSVmxk27iFyuQfvDPVoWuIW/5X3X9dbXxm9qP5Jcwd4GdJofHXdO/WiunRANcrguDGDSoE3u3hQSJzPYmTWUFMsg9oSTjCIi6x0GE35Ikv/d140ImBzFzdZDK/gNWzN+hOvOjjypLZ2HNCkZDS7Qx5mSAoHj2GABEUMG3wh1qAhKCwJPmVurgym6G7ePVgoNtFmJJnyIfSJtgfdptl9c4TeHe0XzqW6bV vagrant@localhost.localdomain"
    }
 }
}
