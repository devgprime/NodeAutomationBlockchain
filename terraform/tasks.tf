resource "null_resource" "docker_installation" {
  depends_on = [azurerm_virtual_machine.vm, azurerm_public_ip.pip]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.pip.ip_address
      user        = "adminuser"
      private_key = file("/home/azuserone/.ssh/id_rsa")
    }

    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu focal stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
      "sudo docker login dgdevacr.azurecr.io -u dgdevacr -p L+c0UqIrjki09MKpplo3H/sNv+tKtl/4L+Dk2L/YjX+ACRD6OrMZ",
      "sudo docker pull dgdevacr.azurecr.io/myapi",
   
      "timeout=180",  # 3 minutes timeout
      "start_time=$(date +%s)",
      "while [[ $(sudo docker images -q dgdevacr.azurecr.io/myapi) == '' ]]; do",
      "  echo 'Waiting for Docker image to be pulled...'",
      "  sleep 5",
      "  current_time=$(date +%s)",
      "  elapsed_time=$((current_time - start_time))",
      "  if [[ $elapsed_time -ge $timeout ]]; then",
      "    echo 'Timeout: Docker image not pulled within $timeout seconds.'",
      "    exit 1",
      "  fi",
      "done",
      "echo 'Docker image pulled successfully. Proceeding to run the image.'",
      "timeout=4",
      "sudo docker run -p 3000:3000 -d dgdevacr.azurecr.io/myapi:latest",
      "echo 'Running container on exposed port 3000' "
    ]
  }
}
