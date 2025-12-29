# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-29

### � First NOfficial Release

This is the first official tagged release of the VPC Endpoint module with full PC-IAC compliance.

### ✨ Added
- **PC-IAC Compliance**: Full compliance with 26 PC-IAC governance rules
- **Map-Based Configuration**: `vpc_endpoints` variable using map(object()) for better resource management
- **For_Each Implementation**: Granular resource control using `for_each` instead of `count`
- **New Files**:
  - `versions.tf`: Terraform and provider version requirements
  - `locals.tf`: Centralized nomenclature and data transformations
  - `data.tf`: Data sources for AWS account and region
  - `providers.tf`: Provider configuration with alias support
- **Input Validations**: Added validations for `client`, `project`, `environment`, and `vpc_endpoint_type`
- **Comprehensive Outputs**: 
  - `vpc_endpoint_ids`: Map of endpoint IDs
  - `vpc_endpoint_arns`: Map of endpoint ARNs
  - `vpc_endpoint_dns_entries`: DNS entries for Interface endpoints
  - `vpc_endpoint_network_interface_ids`: Network interface IDs
  - `vpc_endpoint_state`: Endpoint states
  - `vpc_endpoint_info`: Complete endpoint information
- **Enhanced Tagging**: Automatic tagging with governance metadata following enterprise standards
- **Complete Sample**: Functional example in `sample/vpce/` with terraform.tfvars.sample

### 🔧 Features
- **Nomenclature**: Centralized naming in `locals.tf` following pattern `{client}-{project}-{environment}-vpce-{key}`
- **Multi-Type Support**: Gateway, Interface, and GatewayLoadBalancer endpoint types
- **Security Hardening**: Conditional application of security groups, subnets, and route tables based on endpoint type
- **Flexible Configuration**: Map-based approach allows easy addition/removal of endpoints
- **Complete Documentation**: README.md with usage examples, PC-IAC compliance details, and migration guides

### 📚 Documentation
- Complete README.md with:
  - Module description and features
  - PC-IAC compliance section
  - Usage examples for all endpoint types
  - Input/output reference tables
  - Sample implementation guide

### 🏗️ Module Structure
```
.
├── CHANGELOG.md
├── README.md
├── catalog-info.yaml
├── data.tf
├── locals.tf
├── main.tf
├── outputs.tf
├── providers.tf
├── sample/
│   ├── README.md
│   └── vpce/
│       ├── data.tf
│       ├── locals.tf
│       ├── main.tf
│       ├── outputs.tf
│       ├── providers.tf
│       ├── terraform.tfvars.sample
│       └── variables.tf
├── variables.tf
└── versions.tf
```

### 🎯 Key Capabilities
- Create multiple VPC Endpoints with a single module call
- Automatic resource naming following enterprise standards
- Type-aware configuration (Gateway vs Interface endpoints)
- Built-in validations for critical variables
- Comprehensive outputs for integration with other modules
- Full compliance with PC-IAC governance rules
