#!/usr/bin/env bats

function test_rg_provisioned()
{
    result=$(az group exists -n ${RESOURCE_GROUP} -o tsv)
    [ "$result" == "true" ]
}

function test_vm_running()
{
    result=$(az vm get-instance-view -g ${RESOURCE_GROUP} -n ${VM_NAME} --query "instanceView.statuses[1].displayStatus" | sed 's/"//g')
    [ "$result" == "VM running" ]
}

setup() {
    JENKINS_RESOURCE_GROUP="ptc-cicd-${ENV_NAME}-rg"
    NETWORK_RESOURCE_GROUP="shr-ntwk-${ENV_NAME}-rg"
    APP_RESOURCE_GROUP="ptc-app-${ENV_NAME}-rg"

    JENKINS_VM_NAME="ptc-cicd-${ENV_NAME}-vm"
    APP_VM_NAME="ptc-app-${ENV_NAME}-vm"
}

#Validate RG Creations
@test "If network_rg created" {
    RESOURCE_GROUP="$NETWORK_RESOURCE_GROUP"
    test_rg_provisioned
}

@test "If jenkins_rg created" {
    RESOURCE_GROUP="$JENKINS_RESOURCE_GROUP"
    test_rg_provisioned
}

@test "If app_rg created" {
    RESOURCE_GROUP="$APP_RESOURCE_GROUP"
    test_rg_provisioned
}

#Validate VM Creations
@test "If jenkins_vm running" {
    RESOURCE_GROUP="$JENKINS_RESOURCE_GROUP"
    VM_NAME="$JENKINS_VM_NAME"
    test_vm_running
}

@test "If app_vm running" {
    RESOURCE_GROUP="$APP_RESOURCE_GROUP"
    VM_NAME="$APP_VM_NAME"
    test_vm_running
}