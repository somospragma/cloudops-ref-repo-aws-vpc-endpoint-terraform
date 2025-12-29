###########################################
######## VPC Endpoint Resources ###########
###########################################

# PC-IAC-010: For_Each obligatorio para gestión granular
# PC-IAC-020: Hardenizado de seguridad aplicado

resource "aws_vpc_endpoint" "this" {
  provider = aws.project
  
  for_each = var.vpc_endpoints

  vpc_id              = each.value.vpc_id
  service_name        = each.value.service_name
  vpc_endpoint_type   = each.value.vpc_endpoint_type
  private_dns_enabled = each.value.private_dns_enabled
  
  # Aplicar security groups solo para Interface endpoints
  security_group_ids = each.value.vpc_endpoint_type == "Interface" ? each.value.security_group_ids : null
  
  # Aplicar subnets solo para Interface y GatewayLoadBalancer endpoints
  subnet_ids = contains(["Interface", "GatewayLoadBalancer"], each.value.vpc_endpoint_type) ? each.value.subnet_ids : null
  
  # Aplicar route tables solo para Gateway endpoints
  route_table_ids = each.value.vpc_endpoint_type == "Gateway" ? each.value.route_table_ids : null

  tags = merge(
    local.common_tags,
    {
      Name         = local.vpc_endpoint_names[each.key]
      EndpointType = each.value.vpc_endpoint_type
      ServiceName  = each.value.service_name
    }
  )
}
