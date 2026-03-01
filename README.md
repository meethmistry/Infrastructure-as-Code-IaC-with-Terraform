# 🚀 Terraform AWS

## 📋 Project Overview
This project demonstrates Infrastructure as Code using Terraform to deploy a complete AWS environment including networking, security groups, EC2 instances, and a database server. The project spans 10 days covering everything from basic networking to full stack validation and cleanup.

## 🏗️ Architecture
Internet
│
▼
┌─────────────────────────────────┐
│ Internet Gateway (IGW) │
└─────────────────────────────────┘
│
▼
┌─────────────────────────────────┐
│ Public Route Table │
│ (0.0.0.0/0 → IGW) │
└─────────────────────────────────┘
│
▼
┌─────────────────────────────────┐      ┌─────────────────────────────────┐
│ Public Subnet (10.0.1.0/24)     │      │ Private Subnet (10.0.2.0/24)     │
│                                 │      │                                 │
│ ┌─────────────────────────┐     │      │ ┌─────────────────────────┐     │
│ │ Web Server               │     │      │ │ DB Server               │     │
│ │ Public IP:               │     │      │ │ Private IP:             │     │
│ │ 44.211.184.124           │     │      │ │ 10.0.2.40               │     │
│ │ Security Group:          │     │      │ │ Security Group:         │     │
│ │ web-sg                   │     │      │ │ db-sg                   │     │
│ │ (Port 80,22)             │     │      │ │ (Port 3306 from web)    │     │
│ └─────────────────────────┘     │      │ └─────────────────────────┘     │
│                                 │      │                                 │
│ └─────────────────────┼─────────┼──────┘                                 │
│                       │         │                                        │
└─────────────────────────────────┘ └─────────────────────────────────────┘
                        │
                        ▼
               ┌─────────────────────┐
               │ NAT Gateway         │
               │ (Private subnet     │
               │ internet access)    │
               └─────────────────────┘

## 📁 Repository Structure
terraform-aws-project/
├── provider.tf        # AWS provider configuration
├── variables.tf       # Input variables
├── terraform.tfvars   # Variable values (gitignored)
├── network.tf         # VPC, subnets, IGW, route tables
├── security.tf        # Security groups
├── iam.tf             # IAM roles and profiles
├── compute.tf         # EC2 instances
├── outputs.tf         # Output values
├── README.md          # This documentation