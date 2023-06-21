resource "azurerm_public_ip" "pip" {
  name                = "mypip"
  location            = "Central India"
  resource_group_name = "dgdevice"
  allocation_method   = "Dynamic"
}

data "azurerm_virtual_network" "vnet" {
  name                = "dgdevicevm-vnet"
  resource_group_name = "dgdevice"
}

data "azurerm_subnet" "subnet" {
  name                 = "default"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "vm"
  location              = "Central India"
  resource_group_name   = "dgdevice"
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_D2s_v3"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "vm"
    admin_username = "adminuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/adminuser/.ssh/authorized_keys"
      key_data = file("/home/azuserone/.ssh/id_rsa.pub")
    }
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "nic"
  location            = "Central India"
  resource_group_name = "dgdevice"

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

data "azurerm_network_security_group" "nsg" {
  name                = "dgdevicevm-nsg"
  resource_group_name = "dgdevice"
}

output "vm_configuration" {
  value = azurerm_virtual_machine.vm
  sensitive = true
}

output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
  sensitive = false
}