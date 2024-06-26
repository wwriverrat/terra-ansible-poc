
# Must specify a target environment from the approved list
variable "env" {
  type        = string
  description = "Must specify a valid environment"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.env)
    error_message = "The 'env' value you supplied must be of approved values."
  }
}

# ---------------------------
# EC2 instance variables
# ---------------------------

# Overall shortname of this application
variable "application_name" {
  description = "Name of application instance supports"
  type        = string
  default     = "ai-bot"
}

variable "ssh_private_key_location" {
  description = "Location of private key to use for ssh communications"
  type        = string
  default     = "~/.ssh/id_ed25519_dev_play"
}

# ------ CI servers --------
variable "ci_instance_type" {
  description = "Instance type for CI server"
  type        = string
  default     = "ci_server"
}

# ------ DB servers --------
variable "db_instance_type" {
  description = "Instance type for db server"
  type        = string
  default     = "db"
}

variable "db_instance_count" {
  description = "Number of db server instances"
  type        = number
  default     = 1
}

# ------ App servers --------
variable "app_instance_type" {
  description = "Instance type for app server"
  type        = string
  default     = "app"
}

variable "app_instance_count" {
  description = "Number of server instances"
  type        = number
  default     = 1
}

# ------ Web server --------
variable "web_instance_type" {
  description = "Instance type for web server"
  type        = string
  default     = "web"
}

variable "web_instance_count" {
  description = "Number of server instances"
  type        = number
  default     = 2
}

variable "ci_defaults" {
  type = map(string)
  default = {
    "instance_count" = "1"
    "instance_type"  = "t2.micro"
    # ami: derived elsewhere
    # key_name: derived elsewhere
    # security_groups: derived elsewhere
  }
}

variable "ci_prod_overrides" {
  type = map(string)
  default = {
    "instance_count" = "1"
    "instance_type"  = "t3.large"
    # ami: derived elsewhere
    # key_name: derived elsewhere
    # security_groups: derived elsewhere
  }
}


variable "db_defaults" {
  type = map(string)
  default = {
    "instance_count" = "1"
    "instance_type"  = "t2.micro"
    # ami: derived elsewhere
    # key_name: derived elsewhere
    # security_groups: derived elsewhere
  }
}

variable "db_prod_overrides" {
  type = map(string)
  default = {
    "instance_count" = "2"
    "instance_type"  = "t3.large"
    # ami: derived elsewhere
    # key_name: derived elsewhere
    # security_groups: derived elsewhere
  }
}


variable "web_defaults" {
  type = map(string)
  default = {
    "instance_count" = "1"
    "instance_type"  = "t2.micro"
    # ami: derived elsewhere
    # key_name: derived elsewhere
    # security_groups: derived elsewhere
  }
}

variable "web_prod_overrides" {
  type = map(string)
  default = {
    "instance_count" = "4"
    "instance_type"  = "t3.medium"
    # ami: derived elsewhere
    # key_name: derived elsewhere
    # security_groups: derived elsewhere
  }
}

variable "app_defaults" {
  type = map(string)
  default = {
    "instance_count" = "1"
    "instance_type"  = "t2.micro"
    # ami: derived elsewhere
    # key_name: derived elsewhere
    # security_groups: derived elsewhere
  }
}

variable "app_prod_overrides" {
  type = map(string)
  default = {
    "instance_count" = "2"
    "instance_type"  = "t3.medium"
    # ami: derived elsewhere
    # key_name: derived elsewhere
    # security_groups: derived elsewhere
  }
}
