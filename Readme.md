# Automating the setup of Private Blockchain
![image](https://github.com/devgprime/NodeAutomationBlockchain/assets/131144462/08abad9b-eca9-4fcf-b764-b2f77149f61b)

User Initiates Provisioning Request:
The user initiates the provisioning request through a user interface or Azure Pipeline, specifying the desired node specifications and count.

Terraform Provisioning:
The request is passed to Terraform, which provisions the virtual machines (VMs) with the specified specifications using Azure APIs.
Terraform also provisions the associated Virtual Networks (VNets), subnets, NSGs, and network interfaces.

Ansible Configuration Management:
Once the VMs are provisioned, Ansible is triggered to perform configuration management.
Ansible playbooks and roles are executed to configure the VMs with the required internal services such as Docker or Kubernetes.

Docker/Kubernetes Deployment:
Using the specified cloud image repository, the Geth client image is deployed on each VM using Docker or Kubernetes.
The image includes the necessary specifications like network ID, genesis block, boot nodes, and other network parameters.

Geth Client Startup:
A startup script or service manager like systemd is used to start the Geth client on each VM, initiating the synchronization process with the private Ethereum network.

Validator Functionality Activation:
With the Geth client running, the validator functionality is activated on each VM by submitting a staking transaction using the associated Ethereum account.

Resource Monitoring and Alerting:
Azure Monitor or Prometheus is configured to monitor the containers or pods running the Geth client on the VMs.
Key metrics such as block propagation time, network latency, and resource utilization are monitored, and alerts are set up for any anomalies.

Private Key Storage and Retrieval:
Azure Key Vault is utilized to securely store and retrieve the private keys associated with the Ethereum accounts used by the validator nodes.

A user just needs to trigger the setup.sh script and it will take care of the entire setup.


