#!/usr/bin/env bash
#set -x
set -euo pipefail

# # Install Azure cli
apt update
apt -y install ca-certificates curl apt-transport-https lsb-release gnupg
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $${AZ_REPO} main" | tee /etc/apt/sources.list.d/azure-cli.list

apt update
apt -y install azure-cli

# Install Ansible
echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 && \
apt update && \
apt -y install ansible

#Install JRE
apt -y install openjdk-8-jre
