
# SETUP

_How do use this repo??? Does it really work?_

The following describes steps needed to get you working with this repo.

## Cloud Account
In order to deploy cool things into "cloud", you will need a cloud account to
work with. This repository was developed with a free AWS account and very
likely will only work on AWS.

Steps needed to get yourself setup:
1. Acquire or use an AWS account.

   While developing this, I use the
   [AWS Free Account signup](https://portal.aws.amazon.com/billing/signup?refid=em_127222&p=free&c=hp&z=1&redirect_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation#/start/email)
   page to get started.
2. Create a IAM user on AWS (this is optional if you plan on using the 
   not-recommended root acct)

   Summary of steps needed:
   1. Navigate to AWS IAM configuration
   2. Navigate to "User Groups"
   3. Create a new user group with an appropriate name 
   4. Add the following permissions to this group: AmazonEC2FullAccess, 
      AWSImageBuilderFullAccess
   5. Navigate to "Users"
   6. Create a user and add that user to the group you had created
   7. Within that user, invoke "Create access key". Record both the Access Key 
      and the Secret Access Key (for later)

3. Install AWS CLI 

   1. Follow instructions provided on 
      [AWS user guide for installing CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) 
   2. Run `aws configure` and use the secrets you acquired above.

## Ansible
Ths following is an opinionated technique for installing Ansible isolated
to a virtual environment dedicated to this project. This is to ensure
that this project and its packages/dependencies will not _break_ your OS's
base Python and also ensures it gets the requirements needed to work.

### Install pyenv
On Mac using [Homebrew](https://brew.sh/):
1. `brew install pyenv`

   1. Follow [pyenv Installation Instructions](https://github.com/pyenv/pyenv/blob/master/README.md#homebrew-in-macos)
      making sure you follow the `bash_profile` additions to ensure pyenv is
      always available. 
   2. Install an appropriate Python for this repo
   
      ```commandline
      # To list available python versions
      pyenv install -list
      
      # ... will display a LOT of python versions you can install
      
      # Install an appropriate version (example, but should be upgradable over time)
      pyenv install 3.11.8
      
      # If necessary and you are currently using pyenv,
      # Change the .python-version invoking the following using your favorite version
      pyenv local 3.11.8
      
      # Sanity Check: Are we running right python?
      python --version

      # The output of above command ^ should match that of your target version.
      ```

Not using Mac: Follow instructions as specified by pyenv 
[README](https://github.com/pyenv/pyenv/blob/master/README.md) document

### Install Ansible and dependencies in a virtual environment
Once you have pyenv able to manage Python versions, let's setup a local virtual
environment:

1. Create a python virtual environment

    ```commandline
    # Create a new virtual environment
    python3 -m venv .venv
    
    # Activate local virtual environment
    source .venv/bin/activate
    
    # Great! Now we have an activated virtual environment to work with
    ```
2. Install Ansible and dependencies

    Within the activated command prompt:
    ```commandline
    # Lets install our dependencies (toys)
    pip install -r requirements.txt
    
    # ... the above will install ansible and other libraries
    
    # Install any Ansible galaxy dependencies
    ansible-galaxy collection install -r requirements.yaml
    
    # ... the above will install galaxy dependencies
    ```

## Terraform

Install Terraform per instructions page 
  [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
  on Hashicorp website and follow instructions for you OS.

On Mac, the following is a quick summary from the above:

    ```commandline
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform
    ```

At this point, from within this repo, you should be able to invoke a few
sanity checks:

```commandline
terraform -help

# ... Should provide command line help ...

# Installing autocomplete (to make Terraform commands easier)
terraform -install-autocomplete

# Initialize terraform (to install providers and resources)
terraform init

# To plan a "dev" deploy
terraform plan -var env=dev

# ... Should output terraform planning information ... 
```

## More