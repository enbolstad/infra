# ADME (Azure Data Manager for Energy) Infrastructure

This repository uses **Terraform** to deploy an **ARM template** as a resource for **Azure Data Manager for Energy (ADME)**, because Terraform does not currently support creating ADME resources with private endpoints natively. By leveraging ARM templates, we can still provision and manage the required ADME service within Terraform’s workflow.

The **intended use-case** is to deploy this configuration using **GitHub Actions** workflows.

---

## Table of Contents
1. [Overview](#overview)  
2. [Features](#features)  
3. [Prerequisites](#prerequisites)  
4. [Repository Structure](#repository-structure)  
5. [Usage](#usage)  
   - [Configuration](#configuration)  
   - [Deployment](#deployment)  
   - [Destruction](#destruction)  
6. [GitHub Actions Workflows](#github-actions-workflows)  
7. [Why ARM Templates for ADME?](#why-arm-templates-for-adme)  
8. [License](#license)  
9. [Contributing](#contributing)

---

## Overview

**Azure Data Manager for Energy (ADME)** is a specialized service for managing large volumes of energy data on Azure. Because Terraform does not currently support the `Microsoft.OpenEnergyPlatform/energyServices` resource type with private endpoints, we deploy an **ARM template as a resource** to create the ADME instance.

---

## Features

- **Terraform + ARM**  
  - Terraform deploys the ARM template as a resource to provision ADME.  
- **Private Endpoint Support**  
  - Ensures ADME traffic can remain within a private virtual network.  
- **Automated Cleanup**  
  - Includes a custom approach (via `null_resource` + Azure CLI) to remove ADME resources during destruction.  
- **CI/CD Integration**  
  - GitHub Actions workflows handle deployment and destruction automatically.

---

## Repository Structure

.
├── .github/
│   └── workflows/
│       ├── pr.yml
│       ├── push_nonprod.yml
│       ├── push_prod.yml
│       ├── setTFaccessrights-nonprod.yml
│       └── setTFaccessrights-prod.yml
├── modules/
│   ├── adme_private_endpoints/
│   │   ├── adme_private_endpoints.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   └── variables.tf
│   └── adme_public_endpoints/
│       ├── adme_public_endpoints.tf
│       ├── outputs.tf
│       ├── providers.tf
│       └── variables.tf
├── main.tf
├── providers.tf
├── variables.tf
├── template.json
└── README.md

- **.github/workflows**  
  Holds the GitHub Actions CI/CD workflows for this project.  
- **modules**  
  - **adme_private_endpoints**: Module for private networking and DNS configurations.  
  - **adme_public_endpoints**: Module for public endpoint connectivity.  
- **main.tf**  
  Terraform entry point, including logic to deploy the ARM template as a resource.  
- **providers.tf**  
  Declares the required Terraform providers (AzureRM).  
- **variables.tf**  
  Defines the configurable inputs (e.g., environment, endpoints, subscription IDs).  
- **template.json**  
  The ARM template that actually provisions ADME.

---

## Usage

### Configuration

1. **Endpoints**  
   - In `variables.tf`, set `var.endpoints` to `"public"` or `"private"`.  
   - Default is `"public"`.
   
2. **Environment & Subscriptions**  
   - Set `var.environment` to `"nonprod"` or `"prod"`.  
   - Update subscription IDs as needed in `variables.tf`.

3. **Tenant & Service Principal**  
   - Configure your Azure tenant (`var.tenant_id`).  
   - Store credentials in GitHub Secrets (`AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_TENANT_ID`).

### Deployment

1. **Push or Merge to a Target Branch**  
   - Create/checkout a feature branch, make changes, push them, and open a pull request into the desired branch.  
   - Once merged, use **GitHub Actions** to deploy the infrastructure.


## GitHub Actions Workflows

- **pr.yml**  
  Runs `terraform fmt` and `terraform validate` on pull requests.
  Writes a comment on the pull request with the changes that will happen to the infrastructure on new deployments.
- **push_nonprod.yml** / **push_prod.yml**  
  Deploy changes to respective environments.  
- **setTFaccessrights-nonprod.yml** / **setTFaccessrights-prod.yml**  
  Configures Terraform permissions for Azure resources in each environment.

---

## Why ARM Templates for ADME?

Terraform does not support deploying the ADME resource type with private endpoints. Consequently:

- We deploy the **ARM template as a Terraform resource** to create/update ADME.  
- **Azure CLI** handles ADME deletion, invoked in Terraform via a `null_resource`.

---

## Contributing

1. **Create a Branch**  
   - Make a new branch off your environment branch (`nonprod`, `prod`, or `main`).  
2. **Develop & Commit**  
   - Implement and commit your changes.  
3. **Open a Pull Request**  
   - Merge your feature branch into the target environment branch.  
   - The GitHub Actions workflow will validate and then deploy if checks pass.
