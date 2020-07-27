#!/usr/bin/bash
keyprefix=$1

az login
environment="dev"
STORAGE_ACCOUNT="ptcshrinfratistoresta"
RESOURCE_GROUP="ptc-shrinfra-rg"
ARM_ACCESS_KEY=$(az storage account keys list --account-name "${STORAGE_ACCOUNT}" --resource-group "${RESOURCE_GROUP}" | jq -r '.[0].value')

terraform init -upgrade -input=false \
-backend-config="resource_group_name=${RESOURCE_GROUP}" \
-backend-config="storage_account_name=${STORAGE_ACCOUNT}" \
-backend-config="container_name=terraform" \
-backend-config="key=${environment}\\${keyprefix}.tfstate"