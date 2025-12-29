###########################################
######## Sample Outputs ###################
###########################################

output "vpc_endpoint_ids" {
  description = "Map of VPC Endpoint IDs"
  value       = module.vpc_endpoints.vpc_endpoint_ids
}

output "vpc_endpoint_arns" {
  description = "Map of VPC Endpoint ARNs"
  value       = module.vpc_endpoints.vpc_endpoint_arns
}

output "vpc_endpoint_info" {
  description = "Complete information of all VPC Endpoints"
  value       = module.vpc_endpoints.vpc_endpoint_info
}
