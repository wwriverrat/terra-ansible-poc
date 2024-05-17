
# ------------------- Setup  -------------------

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    ansible = {
      source = "ansible/ansible"
    }

    http = {
      source = "hashicorp/http"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.2"
    }
  }

}

# Validation that ensures that your app_environment matches your workspace
resource "null_resource" "env_precondition_validation" {
  lifecycle {
    precondition {
      # Terraform workspace must match `app_env`
      condition     = (terraform.workspace == format("%s_%s", var.application_name, var.env))
      error_message = <<EOT
VALIDATION ERROR: Your current workspace (${terraform.workspace}) MUST be
consistent with app and environment (env). As run, that would be:
${format("%s_%s", var.application_name, var.env)}

Getting setup would take both or just the second of these commands:

terraform workspace select ${format("%s_%s", var.application_name, var.env)}
terraform workspace select ${format("%s_%s", var.application_name, var.env)}

Please review your application name, environment and workspace so this run
will be isolated to an appropriate workspace.
EOT
    }
  }
}
provider "aws" {
  region = "us-west-2"
}

provider "ansible" {}

resource "ansible_vault" "secrets" {
  vault_file          = format("ansible/vault_%s.yaml.enc", var.env)
  vault_password_file = format("~/.ssh/vault-pass-%s.txt", var.env)
}

locals {
  decoded_vault_yaml = yamldecode(ansible_vault.secrets.yaml)
}

# ------------------- Server instance specifications ----------------

# Make public key available
resource "aws_key_pair" "dev_key" {
  # From ~/.ssh/id_ed25519_dev_play.pub
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL71YaY1HNHHnZbnl4NLpAZDT7pe7dkEvdHVp+fPf33S wwriverrat@cox.net"
  key_name   = "dev_key"
}

# Get latest Ubuntu base ami
data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "ci_server" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.dev_key.key_name
  security_groups = ["${aws_security_group.ci_access.name}"]
  tags = {
    Name        = format("%s_%s_%s", var.application_name, var.env, var.ci_instance_type)
    environment = var.env
  }
}

resource "aws_instance" "db_server" {
  count = var.db_instance_count

  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.dev_key.key_name
  security_groups = ["${aws_security_group.ci_access.name}"]
  tags = {
    Name = format("%s_%s_%s_%s", var.application_name, var.env, var.db_instance_type, count.index)
  }
}

#resource "aws_instance" "app_server" {
#  count = var.app_instance_count
#
#  ami = data.aws_ami.ubuntu.id
#  instance_type = "t2.micro"
#
#  key_name        = aws_key_pair.dev_key.key_name
#  security_groups = ["${aws_security_group.ci_access.name}"]
#
#  tags = {
#    Name = format("%s_%s_%s_%s", var.application_name, var.env, var.app_instance_type, count.index)
#  }
#}

#resource "aws_instance" "web_server" {
#  count = var.web_instance_count
#
#  ami = data.aws_ami.ubuntu.id
#  instance_type = "t2.micro"
#
#  key_name        = aws_key_pair.dev_key.key_name
#  security_groups = ["${aws_security_group.ci_access.name}"]
#
#  tags = {
#    Name = format("%s_%s_%s_%s", var.application_name, var.env, var.web_instance_type, count.index)
#  }
#}


# ------------------- Ansible wiring ----------------

resource "ansible_group" "ci_servers" {
  name = "ci_servers"
  variables = {
    ansible_user                 = "ubuntu"
    ansible_ssh_private_key_file = var.ssh_private_key_location
    ansible_python_interpreter   = "/usr/bin/python3"
    yaml_secret                  = local.decoded_vault_yaml.db_username
  }
}

resource "ansible_host" "ci_server" {
  name   = aws_instance.ci_server.public_dns
  groups = [ansible_group.ci_servers.name]
}

resource "ansible_group" "db_servers" {
  name = "db_servers"
  variables = {
    ansible_user                 = "ubuntu"
    ansible_ssh_private_key_file = var.ssh_private_key_location
    ansible_python_interpreter   = "/usr/bin/python3"
    yaml_secret                  = local.decoded_vault_yaml.db_username
  }
}

resource "ansible_host" "db_server" {
  for_each = { for k, v in aws_instance.db_server : k => v }
  name     = each.value.public_dns

  groups = [ansible_group.db_servers.name]
}

# resource "ansible_host" "db_server" {
#   name   = aws_instance.db_server.public_dns
#   groups = [ansible_group.db_servers.name]
# }
