#!/usr/bin/env bats

function test_jenkins_running()
{
    http_response=$(curl -s -o response.txt -w "%{http_code}" http://${VM_IP}:8080)
    [ "$http_response" == "403" ]
}

setup() {
    JENKINS_RESOURCE_GROUP="ptc-cicd-${ENV_NAME}-rg"
    JENKINS_VM_PIP="ptc-cicd-${ENV_NAME}-vm-pip"
}

#Validate Jenkins Creations
@test "If jenkinsnet provisioned" {
    PIP=$(az network public-ip show -g "${JENKINS_RESOURCE_GROUP}" -n "${JENKINS_VM_PIP}" --query "ipAddress" | sed 's/"//g')
    VM_IP="$PIP"
    test_jenkins_running
}