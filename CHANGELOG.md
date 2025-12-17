# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2024-12-17

### 🎯 BREAKING CHANGES
- **Variable Refactoring**: Changed from `endpoint_config` (list) to `vpc_endpoints` (map) for better resource management
- **Resource Naming**: Changed resource name from `aws_vpc_endpoint.endpoint` to `aws_vpc_endpoint.this`
- **For_Each Implementation**: Migrated from `count` to `for_each` for granular resource control
- **Output Structure**: All outputs now return maps keyed by endpoint identifier

### ✨ Added
- **PC-IAC Compliance**: Full compliance with 26 PC-IAC governance rules
- **New Files**:
  - `versions.tf`: Terraform and provider version requirements
  - `locals.tf`: Centralized nomenclature and data transformations
- **Validations**: Added input validations for `client`, `project`, `environment`, and `vpc_endpoint_type`
- **Granular Outputs**: 
  - `vpc_endpoint_ids`: Map of endpoint IDs
  - `vpc_endpoint_arns`: Map of endpoint ARNs
  - `vpc_endpoint_dns_entries`: DNS entries for Interface endpoints
  - `vpc_endpoint_network_interface_ids`: Network interface IDs
  - `vpc_endpoint_state`: Endpoint states
  - `vpc_endpoint_info`: Complete endpoint information
- **Enhanced Tagging**: Automatic tagging with governance metadata

### 🔧 Changed
- **Nomenclature**: Centralized naming in `locals.tf` following pattern `{client}-{project}-{environment}-vpce-{key}`
- **Security Hardening**: Conditional application of security groups, subnets, and route tables based on endpoint type
- **Documentation**: Complete README.md with PC-IAC compliance section

### 🗑️ Removed
- `application` field from endpoint configuration (replaced by map key)
- `enable` flag (use conditional map entries instead)

### 📝 Migration Guide

**Before (v1.x):**
```hcl
endpoint_config = [
  {
    vpc_id              = "vpc-xxx"
    service_name        = "com.amazonaws.us-east-1.s3"
    vpc_endpoint_type   = "Gateway"
    private_dns_enabled = false
    security_group_ids  = []
    subnet_ids          = []
    route_table_ids     = ["rtb-xxx"]
    application         = "s3"
  }
]
```

**After (v2.x):**
```hcl
vpc_endpoints = {
  "s3" = {
    vpc_id            = "vpc-xxx"
    service_name      = "com.amazonaws.us-east-1.s3"
    vpc_endpoint_type = "Gateway"
    route_table_ids   = ["rtb-xxx"]
  }
}
```

## [1.0.0] - 2023-09-20

### ✨ Initial Release
- Basic VPC Endpoint creation
- Support for Gateway, Interface, and GatewayLoadBalancer endpoint types
- Sample implementation
