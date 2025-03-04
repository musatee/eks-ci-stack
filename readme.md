# Automated EKS Deployment with Terraform, Jenkins CI/CD, and Slack Integration

## Overview
This project provisions an **Amazon EKS cluster** using **Terraform** and sets up a complete **CI/CD pipeline** for deploying a FastAPI-based application. The CI/CD process automates the building, pushing, and deployment of the application using **Ansible, Jenkins, and Helmfile**.

## Tech Stack
- **Terraform**: Infrastructure as Code (IaC) for provisioning AWS resources.
- **Amazon EKS**: Managed Kubernetes service for running containerized applications.
- **Jenkins**: CI/CD automation tool for building and deploying the application.
- **Ansible**: Configuration management for building and pushing application images.
- **Docker**: Containerization for the FastAPI application.
- **Helmfile**: Manages Helm charts to continuously deploy applications onto EKS.
- **Slack Notifications**: Integrated with Jenkins to send build and deployment status updates.
- **AWS Services**:
  - **EKS** (Elastic Kubernetes Service)
  - **ECR** (Elastic Container Registry) for storing Docker images
  - **S3** (for storing Terraform state)
  - **IAM Roles** for managing permissions
  - **Route53 & ACM** for domain and SSL certificates
  - **SQS** for queueing events

## Project Workflow
### 1. Infrastructure Provisioning with Terraform
- Uses **Terraform** to provision AWS resources including VPC, EKS cluster, IAM roles, and other required stuff.
- Example command to initialize and apply Terraform configurations:
  ```sh
  terraform init
  terraform apply -auto-approve
  ```

### 2. CI/CD Pipeline with Jenkins
The pipeline automates the following steps:
1. **Code Checkout**: Jenkins pulls the latest code from the repository.
2. **Build & Push Image**:
   - Uses **Ansible** to build a Docker image of the FastAPI application.
   - Pushes the image to **AWS ECR**.
3. **Deploy Application**:
   - Uses **Helmfile** to deploy the application onto the EKS cluster.
   - Updates Kubernetes resources based on new deployments.
4. **Send Notifications**:
   - Jenkins sends build and deployment status updates to **Slack**.

#### Jenkins Pipeline Stages
- **Stage 1**: Checkout repository
- **Stage 2**: Build and push Docker image using Ansible
- **Stage 3**: Deploy application using Helmfile
- **Stage 4**: Verification & health checks
- **Stage 5**: Notify Slack about build & deployment status

## Screenshots
(Add screenshots of your Jenkins pipeline execution, deployment status, and Kubernetes pods.)

## Setup Instructions
### Prerequisites
- AWS account with required permissions
- Terraform installed (`>=1.1.9`)
- Jenkins installed and configured
- Ansible installed (`>=2.9.23`)
- Helm & Helmfile installed
- AWS CLI configured with necessary permissions
- Slack Webhook URL configured for notifications

### Deployment Steps
1. Create a **Multibranch Pipeline Job** in Jenkins.
2. Specify the **Jenkinsfile** in the pipeline configuration.
3. Provide the **repository URL** along with credentials.
4. Trigger the pipeline to **provision infrastructure, deploy, and monitor the application**.
