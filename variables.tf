###########################################
########## Common variables ###############
###########################################

variable "environment" {
  type        = string
  description = "Environment where resources will be deployed"
  
  validation {
    condition     = contains(["dev", "qa", "uat", "prod", "sandbox"], var.environment)
    error_message = "Environment must be one of: dev, qa, uat, prod, sandbox"
  }
}

variable "client" {
  type        = string
  description = "Client name"
  
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.client))
    error_message = "Client must contain only lowercase letters, numbers, and hyphens"
  }
}

variable "project" {
  type        = string  
  description = "Project name"
  
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project))
    error_message = "Project must contain only lowercase letters, numbers, and hyphens"
  }
}

###########################################
####### VPC Endpoint variables ############
###########################################

variable "vpc_endpoints" {
  type = map(object({
    vpc_id              = string
    service_name        = string
    vpc_endpoint_type   = string
    private_dns_enabled = optional(bool, false)
    security_group_ids  = optional(list(string), [])
    subnet_ids          = optional(list(string), [])
    route_table_ids     = optional(list(string), [])
  }))
  description = <<-EOF
    Map of VPC Endpoints to create. Key is the endpoint identifier.
    
    - vpc_id: (string, required) The ID of the VPC in which the endpoint will be used
    - service_name: (string, required) The service name (e.g., com.amazonaws.us-east-1.s3)
    - vpc_endpoint_type: (string, required) The VPC endpoint type: Gateway, GatewayLoadBalancer, or Interface
    - private_dns_enabled: (bool, optional) Whether to associate a private hosted zone. Applicable for Interface endpoints. Default: false
    - security_group_ids: (list(string), optional) Security groups for Interface endpoints. Default: []
    - subnet_ids: (list(string), optional) Subnets for Interface/GatewayLoadBalancer endpoints. Default: []
    - route_table_ids: (list(string), optional) Route tables for Gateway endpoints. Default: []
    
    Example:
    vpc_endpoints = {
      "s3" = {
        vpc_id            = "vpc-xxx"
        service_name      = "com.amazonaws.us-east-1.s3"
        vpc_endpoint_type = "Gateway"
        route_table_ids   = ["rtb-xxx"]
      }
    }
  EOF
  
  validation {
    condition = alltrue([
      for key, config in var.vpc_endpoints :
      contains(["Gateway", "Interface", "GatewayLoadBalancer"], config.vpc_endpoint_type)
    ])
    error_message = "vpc_endpoint_type must be one of: Gateway, Interface, GatewayLoadBalancer"
  }
}