Design and Goals of the Repository
==================================

***End-to-end guide PoC to deploying cloud software***

**Author:** *David Bingham*

## Overview
This repository and its solutions was created to demonstrate how IaC
(Infrastructure as code) software can be used to automate deployments in a
cloud setting. It is definitely *NOT* the only way to perform these functions,
but has been created to demonstrate how several IoC toolsets can be used to
orchestrate deployments together.

It is intended for this repo and its functionality to evolve and mature over
time.

## Goals

1. Create Terraform code to create deployer-bastion infrastructure (CI).

   Intent: to be able to have IoC code that can rebuild and reconfigure
   a server that can act both as the deployer of this application as well as
   act as an SSH bastion (single or few trusted IP addresses for SSH access).
   When rebuilding this server, the applications will need to allow access
   from the new bastion (via modified security groups)

2. Create Terraform code using best practices to deploy multi-tier 
   infrastructure for application.
   
   Some examples of tiers (if needed): `app, web, deployer-bastion, database`.

3. Use Ansible to leverage the resources using roles appropriate for each 
   resource type.

   Intent: leverage resources such that Ansible can use the Terraform generated
   resources as inventory for ultimate deployment and configuration.

4. Generate simple web application that prompts for AI chatbot input and behind
   the scenes calls chatbot APIs to get and display response

   Intent:
   1. (Web tier) Create simple web interface that allows a simple "What would
      you like to ask the bot" question and displays its response. This tier
      forwards on to our REST API
   2. (App Tier) Create FastAPI or Spring-boot REST application that takes 
      GET request and forwards it on to GPT APIs to obtain response from real
      AI endpoint.
   3. (DB Tier) Create question tracking DB schema that tracks questions on a
      per-user basis.
   4. Create unit/integration tests and ensure tests pass

5. Extend Ansible deployment to include deploying, configuring and base-testing
   the simple web application.

6. Audit application targeting (at minimum): access, security, weaknesses,
   secrets exposure, scalability.

# Storyboarding

The following are more concrete and detailed stories based on problem
decomposition of the above goals. The IDs in this table reflect what goal 
"family" above the story targets (Ex: Goal 1 reflected in 100-based stories,
etc.). This table of stories is intended to evolve, update and change over 
time but not extend beyond the initial PoC.

**Disclaimer**: Ultimately these stories should be handled in Agile story
tracking software (i.e. Jira, GitHub Issues, Trello, etc.), but exists here
until this project has resources and funding.

Acceptable statuses:
* TODO
* In Progress
* QA
* Done

| ID  | Status      | Goal                                                                                      |
|-----|-------------|-------------------------------------------------------------------------------------------|
| 101 | In Progress | Create Terraform code that generates a ci_server/bastion host (to run this code from)     |
| 201 | Done        | Create basic Terraform config for multiple vm types                                       |
| 202 | Done        | Refine terraform to ensure multiple environments are supported (dev, stage, prod)         |
| 203 | Done        | Refine terraform to support secrets in configuration                                      |
| 204 | Done        | Refine terraform to support security groups (see bastion-host)                            |
| 205 | Done        | Ensure terraform-ansible plugins exist and can discover inventory                         |
| 299 | TODO        | TODO(dbingham) Likely more terraform stories here                                         |
| 300 | Done        | Ensure Ansible is able discover and use Terraform resources                               |
| 301 | Done        | Create base playbook common for all "tier" types                                          |
| 302 | Done        | Create playbook for ci_server role                                                        |
| 303 | Done        | Create playbook for database tier role                                                    |
| 304 | TODO        | Create playbook for web/web tier roles                                                    |
| 305 | TODO        | (stretch) Extend playbooks to write IPTables rules into VMs (same as SGs)                 |
| 320 | TODO        | Create playbook(s) to deploy ai-bot code and configuration                                |
| 399 | TODO        | TODO(dbingham) Likely more Ansible stories here                                           |
| 400 | TODO        | Create PoC code that integrates with Chat-GPT (FastAPI or SpringBoot)                     |
| 401 | TODO        | Enhance app to require user login                                                         |
| 402 | TODO        | Enhance app to allow adding/removing/managing users and their roles                       |
| 403 | TODO        | Design schema for tracking GPT calls per user                                             |
| 404 | TODO        | Enhance/Refine web interface to allow GPT question/response                               |
| 405 | TODO        | Enhance ai-bot app record questions on per-user basis                                     |
| 406 | TODO        | Create appropriate deployment packaging automation                                        |
| 407 | TODO        | Ensure packaged and versioned ai-bot app code is made available for deployments           |
| 499 | TODO        | TODO(dbingham) Likely more ai-bot app stories here                                        |
| 500 | TODO        | Enhance Ansible playbooks to also config/deploy ai-bot                                    |
| 501 | TODO        | Ensure SSH access needed by Ansible is only available to deployer addresses               |
| 502 | TODO        | Ensure user login information is secure                                                   |
| 503 | TODO        | Verify port security per resource against what procs are running on it                    |
| 800 | TODO        | Verify secrets safe: secure backing, none leaked in git, none leaked in logs or tf output |
| 801 | TODO        | (Future) Front with a load balancer                                                       |
| 802 | TODO        | (Future) Front with more advanced firewall protections                                    |
| 803 | TODO        | (Future) Throttling requests to prevent DoS style attacks                                 |
| 804 | TODO        | (Future) Separate secrets shared between terraform and ansible into different enc files   |

Note: Typically Git commits should be tied to one of the above stories.
