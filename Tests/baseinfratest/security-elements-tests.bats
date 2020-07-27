#!/usr/bin/env bats

function test_kv_provisioned()
{
    result=$(az keyvault show -g ${RESOURCE_GROUP} -n ${KV_NAME} --query "properties.provisioningState" | sed 's/"//g')
    [ "$result" == "Succeeded" ]
}

function test_kv_networkpolicies()
{
    subnetId=$(az resource show -g ${NETWORK_RG} -n ${SUBNET_NAME} --namespace Microsoft.Network --parent virtualnetworks/${VNET_NAME} --resource-type subnets --query "id" | sed 's/"//g')
    result=$(az keyvault show -g ${RESOURCE_GROUP} -n ${KV_NAME} --query "properties.networkAcls.virtualNetworkRules[0].id" | sed 's/"//g')
    [ "$result" == "$subnetId" ]
}

function test_kv_accesspolicies()
{
    objectId=$(az vm show -g ${RESOURCE_GROUP} -n ${VM_NAME} --query "identity.userAssignedIdentities.principalId" | sed 's/"//g')
    result=$(az keyvault show -g ${RESOURCE_GROUP} -n ${KV_NAME} --query "properties.accessPolicies[*].objectId" -o json)
    echo  "$result.[1]"
    echo "$objectId" 
    [ "$result.[1]" == "$objectId" ]
}

setup() {
    JENKINS_RESOURCE_GROUP="ptc-cicd-${ENV_NAME}-rg"
    NETWORK_RESOURCE_GROUP="shr-ntwk-${ENV_NAME}-rg"
    APP_RESOURCE_GROUP="ptc-app-${ENV_NAME}-rg"
    
    SHR_VNET_NAME="shr-ntwk-${ENV_NAME}-vnet"
    JENKINS_SUBNET_NAME="ptc-cicd-${ENV_NAME}-snt"
    APP_SUBNET_NAME="ptc-app-${ENV_NAME}-snt"

    JENKINS_KV_NAME="ptc-cicd-${ENV_NAME}-kvt"
    APP_KV_NAME="ptc-app-${ENV_NAME}-kvt"

    JENKINS_VM_NAME="ptc-cicd-${ENV_NAME}-vm"
    APP_VM_UAI="ptc-app-${ENV_NAME}-rg-ptc-app-${ENV_NAME}-vm-uai"
}


#Validate kv Creations
@test "If jenkins_kv provisioned" {
    RESOURCE_GROUP="$JENKINS_RESOURCE_GROUP"
    KV_NAME="$JENKINS_KV_NAME"
    test_kv_provisioned
}

#Validate kv Creations
@test "If apps_kv provisioned" {
    RESOURCE_GROUP="$APP_RESOURCE_GROUP"
    KV_NAME="$APP_KV_NAME"
    test_kv_provisioned
}

#Validate kv network policies
@test "If jenkins_kv_policies provisioned" {
    RESOURCE_GROUP="$JENKINS_RESOURCE_GROUP"
    KV_NAME="$JENKINS_KV_NAME"
    NETWORK_RG="$NETWORK_RESOURCE_GROUP"
    VNET_NAME="$SHR_VNET_NAME"
    SUBNET_NAME="$JENKINS_SUBNET_NAME"
    test_kv_networkpolicies
}

#Validate kv access policies
@test "If jenkins_kv_access_policies provisioned" {
    RESOURCE_GROUP="$JENKINS_RESOURCE_GROUP"
    KV_NAME="$JENKINS_KV_NAME"
    VM_NAME="$JENKINS_VM_NAME"

    test_kv_accesspolicies
}