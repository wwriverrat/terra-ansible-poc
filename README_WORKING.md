
# Working with Terraform and Ansible

Assuming that you have everything [Setup](README_SETUP.md), let's see how we
interact with this repo on a ongoing basis.

## Using Terraform

```commandline
# Initialize terraform
terraform init

# ... Terraform initializes plugins and providers ...

# Workspace
# Specifying a workspace that will match your app and env.
# Each workspace represents both the app and its environment.
# Setup workspaces with name matching: <var.application_name>_<var.env>.
# Example for ai-bot in the dev environment:
terraform workspace new ai-bot_dev
terraform workspace select ai-bot_dev

# Plan
# Specifying `env`:     (let terraform ask or provide as a var)
terraform plan                  # Terraform will ask for `env`
terraform plan -var env=dev     # Provided on cli will not ask

# ... Terraform compares current state to AWS and displays its plan (no-op)

# Apply
terraform apply -var env=dev

# ... Terraform "makes-it-so" ... (you will have to approve "yes") ...

# Destroy
# CAUTION: Yikes! Careful here! It destroys all that it manages.
terraform destroy -var env=dev

# ... Terraform "the destroyer" nukes all (you will have to approve "yes") ...
```

## Ansible Vault - Secrets
This repo currently uses 
[Ansible Vault](https://docs.ansible.com/ansible/latest/vault_guide/index.html) 
as its secret store. The following section describes how to manage secrets
within.

Files currently under management are all files that return when running:
```commandline
ls -la ansible/vault*.yaml.enc
```
This allows us to set completely different secrets/credentials per environment
in a "share-nothing" fashion.

#### Adding/Modifying secrets
Workflow for editing/adding/rotating secrets (examples below for `dev`)
1. Decrypt vault:
   ```commandline
   ansible-vault decrypt --vault-password-file ~/.ssh/vault-pass-dev.txt --output ansible/vault_dev.yaml ansible/vault_dev.yaml.enc
   ```
2. Edit the resulting `ansible/vault_dev.yaml` file. Add keys, modify values,
   remove keys as you see fit.
3. When happy with new version re-encrypt and overwrite the `enc` file:
   ```commandline
   ansible-vault encrypt --vault-password-file ~/.ssh/vault-pass-dev.txt --output ansible/vault_dev.yaml.enc ansible/vault_dev.yaml
   ```
4. Smoke test the file using
   ```commandline
   terraform plan -var env=dev
   ```

TODO(dbingham) Future safety - Separate terraform and ansible secrets
(if possible) to prevent a leak allowing impact to both infrastructure
and config management.


#### Using secrets
There may be a case where 