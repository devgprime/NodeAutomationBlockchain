# NodeAutomationBlockchain

# BlockchainAutomation
Project Setup
To get started with the project, please follow these steps:

Step 1: Installing Pre-requisites
Before proceeding, ensure that all the necessary pre-requisites are installed on your host/local system. Run the following bash script using the command:

./install.sh

Step 2: Azure Subscription (Optional)
To proceed further and provision a vm, make sure you have an active Azure subscription. 

You need to provide your IaC credentials into this provider.tf.
Also to upload the docker image for the code you are using to the Azure Container Registry, Skip it if you don't want to use different image.
If you already have an account running on portal.azure.com, you can skip this step. Otherwise, perform the following command to log in to your Azure account:

az login --use-device-code
sudo az acr login --name ImageName

Step 3: Provisioning the Virtual Machine and Container

This step involves provisioning a virtual machine and running a container on top of it. This container will communicate externally with Postman. Follow these instructions:

Navigate to the terraform folder.
Run the following command:

./apply.sh

This script will internally call the necessary Terraform scripts to provision the virtual machine, install dependencies on the provisioned VM, pull the image from Azure cloud, and bring up the container on the VM.

At the end of this process, a URL will be exposed, which will appear similar to the following (url will be a dynamic one):

http://4.12.130.2:3000 - This URL will be used for further communication with the containerized application.

