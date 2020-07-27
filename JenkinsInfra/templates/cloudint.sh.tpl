#!/usr/bin/env bash
#set -x
set -euo pipefail

# Install Azure cli
apt-get update
apt-get -y install ca-certificates curl apt-transport-https lsb-release gnupg
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $${AZ_REPO} main" | tee /etc/apt/sources.list.d/azure-cli.list

apt-get update
apt-get -y install azure-cli

# AZ Login and get private key for SSH 
az login --identity

JENKINSSSHPRIVATEKEY=$(az keyvault secret show --vault-name "${KV_NAME}" --name "${TLS_PRIVATE_KEY}" --query 'value' -o tsv)

cat > ~/.ssh/config << EOF
Host *
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
EOF
chmod 600 ~/.ssh/config
cat > ~/.ssh/id_rsa << EOF
$${JENKINSSSHPRIVATEKEY}
EOF
chmod 600 ~/.ssh/id_rsa

# Initialize CI/CD setup
git clone git@github.com:ravalierukulla/jenkinscloudinit.git
cd jenkinscloudinit
chmod +x run.sh
./run.sh