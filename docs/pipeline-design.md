# CI/CD Pipeline Design

## Overview

This project implements a GitHub Actions CI/CD workflow for Azure infrastructure managed with Bicep.

The pipeline separates infrastructure validation, development deployment, and controlled production deployment while using Microsoft Entra workload identity federation for passwordless Azure authentication.

## Pipeline Stages

### 1. Pull Request Validation

Changes are developed on feature branches and submitted through pull requests to `main`.

The validation workflow performs:

- GitHub repository checkout
- Azure authentication using OIDC
- Bicep template compilation
- DEV parameter compilation
- PROD parameter compilation
- Azure deployment validation
- Azure What-If analysis

Infrastructure changes must successfully pass validation before they are merged.

### 2. Development Deployment

Infrastructure changes merged into `main` automatically trigger the DEV deployment workflow when files under `infra/` change.

The workflow:

1. Authenticates to Azure through OIDC.
2. Validates the deployment.
3. Runs Azure What-If.
4. Deploys the Bicep infrastructure to `rg-cicd-dev`.

The GitHub `development` environment is restricted to deployments originating from `main`.

### 3. Production Deployment

Production deployment is separated from automatic DEV deployment.

The production workflow:

- Uses `workflow_dispatch` for manual initiation.
- Targets the GitHub `production` environment.
- Restricts deployment to `main`.
- Requires reviewer approval.
- Uses a dedicated production federated identity credential.

During portfolio validation, the production workflow was intentionally stopped at the approval gate. Production infrastructure was not deployed.

## Authentication

The project uses GitHub Actions OIDC federation with Microsoft Entra ID.

This eliminates the need to store a long-lived Azure client secret in GitHub.

Separate federated identity credentials are used for:

- Pull request validation
- `main` branch authentication
- Development environment deployments
- Production environment deployments

## Azure Authorization

The deployment service principal uses Azure RBAC with Contributor access scoped to the appropriate project resource groups.

This avoids granting subscription-wide Contributor permissions to the CI/CD identity.

## Infrastructure

Bicep modules deploy:

- Azure Virtual Network
- Application subnet
- Log Analytics workspace
- Standardized resource tags

DEV and PROD use separate parameter files and non-overlapping address spaces.

## Deployment Safety

The pipeline uses several controls to reduce deployment risk:

- Pull-request validation
- Bicep compilation
- Azure deployment validation
- Azure What-If
- Environment-specific parameters
- Branch restrictions
- Resource-group-scoped RBAC
- Passwordless OIDC authentication
- Manual production trigger
- Production reviewer approval

## Validation Results

The DEV pipeline successfully deployed:

- `vnet-cicd-dev`
- `snet-app`
- `law-cicd-dev`

The production workflow successfully reached its required approval gate and was intentionally cancelled before deployment.