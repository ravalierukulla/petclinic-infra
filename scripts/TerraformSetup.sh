#!/bin/bash
# Arguments
# -l LOCATION
# -e ENVIRONMENT Short Name (DEV,PRD)
#
# "Az Login" should be executed before running this script
while getopts e:l:o:r: option
do
case "${option}"
	in
        e) ENVIRONMENTCODE=${OPTARG};;
		l) LOCATION=${OPTARG};;
        r) RGPrefix=${OPTARG};;
	esac
done

# initialize default values
if [ -z ${LOCATION} ]; then LOCATION="eastus2"; fi 
if [ -z ${ENVIRONMENTCODE} ]; then ENVIRONMENTCODE="dev"; fi 
if [ -z ${RGPrefix} ]; then RGPrefix="ptc-shrinfra"; fi

RESOURCE_GROUP=''${RGPrefix}-${ENVIRONMENTCODE}'-rg'
STORAGE_ACCOUNT=ptc${ENVIRONMENTCODE}"tistoresta"


RESOURCE_GROUP=${RESOURCE_GROUP,,}
STORAGE_ACCOUNT=${STORAGE_ACCOUNT,,}

echo ${STORAGE_ACCOUNT}
echo ${RESOURCE_GROUP}

ARM_SUBSCRIPTION_ID=$(az account show --query id --out tsv)


if [ $(az group exists -n ${RESOURCE_GROUP}} -o tsv) = false ]
then
    echo "${RESOURCE_GROUP} RG was not found. creating"
az group create --location ${LOCATION} --name ${RESOURCE_GROUP}
else
    echo "Using existing resource group ${RESOURCE_GROUP}}"
fi

az storage account show -n ${STORAGE_ACCOUNT} -g ${RESOURCE_GROUP} &> /dev/null
set -e
if [ $? -eq 0 ]
then
    echo "Using storage account ${STORAGE_ACCOUNT} in resource group ${RESOURCE_GROUP}}"
else
    echo "${STORAGE_ACCOUNT} storage account in resource group ${RESOURCE_GROUP}} was not found, creating"
    az storage account create -n ${STORAGE_ACCOUNT} -g ${RESOURCE_GROUP}
    
fi
az storage container create --name "terraform" --account-name ${STORAGE_ACCOUNT} 

# Using this script we will fetch storage key which is required in terraform file to authenticate backend stoarge account
ARM_ACCESS_KEY=$(az storage account keys list --account-name "${STORAGE_ACCOUNT}" --resource-group "${RESOURCE_GROUP}" | jq -r '.[0].value')