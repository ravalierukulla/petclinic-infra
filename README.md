# petclinic-infra
petclinic-infra repo helps creating infra components both for setting up CI/CD and also application specific resources creation for spring-petclinic application.


## Description:
-  BaseInfra folder consists of terraform scripts to setup base netowrk infra such as VNETs, Subnets.
-  JenkinsInfra folder consists of terraform scripts to provisions Jenkins running as Docker container on Linux VM and required infra.
-  PetclinicappInfra folder consists of terraform scripts to provisions resources required for petclinic app deployment such container on Linux VM,KeyVault, required access,Ansible, JRE installation.
-  Terraform/Modules folder consists of reusable terraform scripts to provisions resources such as keyvault, storage account, Virtual network
-  Tests folder consists of bats test scripts to validate the infra setup such as resources provisioning, access controls, Jenkins setup
	
## Getting Started
### Prerequisites
- [Terraform Installed](https://www.terraform.io/downloads.html).  Download appropriate Terraform version.
- [Docker install](https://docs.docker.com/engine/install/)
- [Git](https://www.git-scm.com/)
  * Please download git from here.
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
  *  For the purpose of this tutorial we would work with Azure CLI version 2.0.4 or later which is available for Windows, Mac and Linux
- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/free/dotnet/).


### Solution Setup
- [Create Azure Resource Group](https://docs.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest) for setting up terraform backend storage
- [Create Azure Storage Account](https://docs.microsoft.com/en-us/cli/azure/storage/container?view=azure-cli-latest), and setup terraform container to store terraform states.


#### Run Infra scripts locally
- Using Azure CLI. Login to azure account using "az login" command and set the default subscription.
- After creating terraform backend state storage account.(Refer to Scripts/terraformsetup.sh file for details)
- Set backend config for running terraform such considering Azure RM storage account for backend state store.(Refer to Scripts/terrainit.sh file for details) 
- Run terraform init, plan, apply with required arguments such as Environment, resources prefixes, locations apart from backend config (currently all required details are present in defaults for simplicity)
- 

#### Run the Associated tests locally
- Once the infra creation is compelete, to validate resource provisioning and setup, run docker file under Tests folder with following required arguments.
- Set IS_LOCAL argument to false when running on vm, as scripts can use VMs Identity to run az cli commands.
- docker build --file  Dockerfile.bootstraptest --no-cache --rm --build-arg IS_LOCAL=true --build-arg ENV_NAME={env_name} --build-arg SUBSCRIPTION_ID={Azure_Subscription_id} .
