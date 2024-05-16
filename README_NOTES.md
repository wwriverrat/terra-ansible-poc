
## Random captured notes

This is a location where I "splat" seemingly random notes so the information
is not lost! Over time, these notes end up in other documentation contained
within this repo (likely the [Working](README_WORKING) file).


Installed ansible's Terraform plugin into Ansible:
`ansible-galaxy collection install cloud.terraform`

Example ssh-ing into a spun up instance 
`ssh -i ~/.ssh/id_ed25519 -l ubuntu 54.190.193.154`

Example Ansible run to install ci_servers
`ansible-playbook -b --private-key ~/.ssh/id_ed25519 -i inventory.yaml ci_servers.yaml`
