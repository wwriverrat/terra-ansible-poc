AI-BOT Deployer
===============

***End-to-end PoC to deploying cloud software***

**Author:** *David Bingham*

## Overview

_Dude! I wanna be able to regularly deploy my cool new AI application! How can
I do this?!?_

As a application designer, software engineer, or product manager have you ever 
been curious how one might automate code that?:

* Allows your cool and funky new software to exist in a git repo
* Builds the infrastructure on which your application will deploy
* Deploys and configures your application within that infrastructure.
* Orchestrates this all together to ensure your app is up and running
* Ultimately..., it launches your shiny new application!!!

The following repository is a "proof of concept" whose intent is to

1. Create a cool (yet very simple) multi-tiered ai-bot that initially leverages
   existing ChatGPT backend APIs. This is our "application"
2. Leverage Infrastructure-as-Code (IaC) techniques to build multi-tier cloud
   infrastructure. This will use Terraform.
3. Utilize this shiny new infrastructure by deploying your software as well as 
   base software and ensures it is running. This utilizes Ansible
4. Do all of the above striving for best-practices and safety. This leverages
   several practices that keeps you safe (ansible-vault, security groups,
   bastion host etc.).

## Tech Stack
Currently this repo uses the following tech:

| Tech          | Description                                        |
|---------------|----------------------------------------------------|
| AWS           | AWS CLI, free account, IAM user                    |
| Terraform     | Using `ansible/ansible` plugin                     |
| Ansible       | Using galaxy cloud.terraform plugin                |
| Ansible-Vault | Managing secrets (could be modifed to aws secrets) |

As this repo matures, new may be added.

## More Documents

Further Reading:
* [Setup](README_SETUP) - How to setup your environment in order to run this
* [Design](README_DESIGN) - Design considerations and initial stories for PoC
* [Working](README_WORKING) - How to work with this Terraform and Ansible 
  implementation to work through the end-to-end processes.
* [Notes](README_NOTES) - Random notes taken to capture important info. These
  will ultimately end up in other docs and the notes file be removed.
