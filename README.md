# AWS Private VPC Infrastructure

This project creates a production-ready AWS VPC infrastructure using Terraform, with a modular design for scalability and maintainability. The infrastructure includes a private VPC, public and private subnets across multiple AZs, NAT Gateways, security groups, network ACLs, and VPC endpoints.

## Prerequisites

- Terraform >= 1.5.0
- AWS CLI configured with appropriate credentials
- AWS account with permissions to create VPC resources

## Directory Structure

```
multi-az-vpc/
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
├── versions.tf
├── modules/
│   ├── vpc/
│   ├── subnets/
│   ├── security/
│   ├── route-tables/
│   └── nat-gateway/
│   ├── vpc-endpoints/
│   ├── flowlogs/
│   └── dhcp/
└── examples/
    └── complete/
```

## Usage

1. Create an`example.tfvars` with your AWS credentials and desired configurations.
2. Run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

## Architecture

- **VPC**: CIDR `10.0.0.0/16`
- **Region**: `ap-south-1`
- **Subnets**:
  - Public: `10.0.1.0/24` (ap-south-1a), `10.0.2.0/24` (ap-south-1b)
  - Private: `10.0.11.0/24` (ap-south-1a), `10.0.12.0/24` (ap-south-1b)
  - Database: `10.0.21.0/24` (ap-south-1a), `10.0.22.0/24` (ap-south-1b)
- **Components**: Internet Gateway, NAT Gateways, Route Tables, Security Groups, Network ACLs, VPC Endpoints, VPC Flow Logs

## Modules

- `vpc`: Configures the VPC, Internet Gateway, and VPC Flow Logs.
- `subnets`: Manages subnets, route tables, NAT Gateways, and Elastic IPs.
- `security`: Configures security groups and network ACLs.

## Inputs

See `variables.tf` for all configurable variables.

## Outputs

See `outputs.tf` for all output values, including VPC ID, subnet IDs, and security group IDs.
