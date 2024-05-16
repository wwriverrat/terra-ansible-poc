#!/bin/bash
#set -eux

# This script captures all of the steps needed to start from nothing and
# deploy a full environment.

# CAUTION: In a production environment, this should be done such that
# if critical components will be altered that your processes do not go down.
# See README_WORKING.md for more details.

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~ Terraform work ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
terraform init
terraform apply -var env=dev --auto-approve

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~ CI Server work ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
ansible-playbook -b -i inventory.yaml ansible/ci_servers.yaml

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~ DB Server work ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
ansible-playbook -b -i inventory.yaml ansible/db_servers.yaml

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~ Done ~~~~~~~~~~~~~~~~~~~~~~~~~~~"
