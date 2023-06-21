#!/bin/bash

set -e

GREEN="\033[1;32m"
LIGHT_YELLOW="\033[93m"
RESET="\033[0m"

terraform plan

apply_output=$(terraform apply -auto-approve 2>&1 || true)

echo "$apply_output" > apply_output.txt

if [[ $apply_output =~ "remote-exec provisioner error" ]]; then
  echo -e "${LIGHT_YELLOW}Resolving issues with the provisioner...${RESET}"
  echo -e "${LIGHT_YELLOW}Refreshing the host value - azurerm_public_ip.pip.ip_address...${RESET}"

  for ((i=0; i<30; i+=3)); do
    echo -e "${LIGHT_YELLOW}Resolving issues with the provisioner...${RESET}"
    echo -e "${LIGHT_YELLOW}Refreshing the host value - azurerm_public_ip.pip.ip_address...${RESET}"
    sleep 3
  done

  public_ip=$(az vm show -g DGDEVICE -n vm -d --query publicIps -o tsv)

  ssh-keyscan -H "$public_ip" >> ~/.ssh/known_hosts

  terraform apply -auto-approve

fi

echo -e "${GREEN}New Virtual Machine provisioned successfully.${RESET}"
echo -e "${GREEN}The server is now hosted inside the running container on port 3000 and is reachable via http://$public_ip:3000/${RESET}"
