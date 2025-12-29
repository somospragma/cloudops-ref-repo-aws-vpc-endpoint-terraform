###########################################
########## Common variables ###############
###########################################

variable "profile" {
  type = string
  description = "Profile name containing the access credentials to deploy the infrastructure on AWS"
}

variable "common_tags" {
    type = map(string)
    description = "Common tags to be applied to the resources"
}

variable "aws_region" {
  type = string
  description = "AWS region where resources will be deployed"
}

variable "environment" {
  type = string
  description = "Environment where resources will be deployed"
}

variable "client" {
  type = string
  description = "Client name"
}

variable "project" {
  type = string  
    description = "Project name"
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
    Leave IDs empty ("", []) to use data sources for dynamic lookup.
  EOF
}