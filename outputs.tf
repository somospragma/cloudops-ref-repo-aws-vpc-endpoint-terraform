###########################################
######## VPC Endpoint Outputs #############
###########################################

# PC-IAC-007: Outputs granulares con ARNs/IDs
# PC-IAC-014: Uso de expresiones para extracción limpia

output "vpc_endpoint_ids" {
  description = "Map of VPC Endpoint IDs"
  value = {
    for key, endpoint in aws_vpc_endpoint.this :
    key => endpoint.id
  }
}

output "vpc_endpoint_arns" {
  description = "Map of VPC Endpoint ARNs"
  value = {
    for key, endpoint in aws_vpc_endpoint.this :
    key => endpoint.arn
  }
}

output "vpc_endpoint_dns_entries" {
  description = "Map of VPC Endpoint DNS entries (for Interface endpoints)"
  value = {
    for key, endpoint in aws_vpc_endpoint.this :
    key => endpoint.dns_entry
  }
}

output "vpc_endpoint_network_interface_ids" {
  description = "Map of VPC Endpoint Network Interface IDs (for Interface endpoints)"
  value = {
    for key, endpoint in aws_vpc_endpoint.this :
    key => endpoint.network_interface_ids
  }
}

output "vpc_endpoint_state" {
  description = "Map of VPC Endpoint states"
  value = {
    for key, endpoint in aws_vpc_endpoint.this :
    key => endpoint.state
  }
}

output "vpc_endpoint_info" {
  description = "Complete information of all VPC Endpoints"
  value = {
    for key, endpoint in aws_vpc_endpoint.this :
    key => {
      id                      = endpoint.id
      arn                     = endpoint.arn
      state                   = endpoint.state
      vpc_endpoint_type       = endpoint.vpc_endpoint_type
      service_name            = endpoint.service_name
      dns_entry               = endpoint.dns_entry
      network_interface_ids   = endpoint.network_interface_ids
      owner_id                = endpoint.owner_id
      requester_managed       = endpoint.requester_managed
    }
  }
}
