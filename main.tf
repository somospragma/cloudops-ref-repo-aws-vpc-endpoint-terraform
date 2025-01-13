#################################################################################
# Resource: aws_vpc_endpoint
#################################################################################

resource "aws_vpc_endpoint" "endpoint" {
  provider = aws.project
  count = length(var.endpoint_config) > 0 ? length(var.endpoint_config) : 0

  vpc_id              = var.endpoint_config[count.index].vpc_id
  service_name        = var.endpoint_config[count.index].service_name
  vpc_endpoint_type   = var.endpoint_config[count.index].vpc_endpoint_type
  private_dns_enabled = var.endpoint_config[count.index].private_dns_enabled
  security_group_ids  = var.endpoint_config[count.index].security_group_ids
  subnet_ids          = var.endpoint_config[count.index].subnet_ids
  route_table_ids     = var.endpoint_config[count.index].route_table_ids

  tags = merge(
    { Name = "${join("-", tolist([var.client, var.project , var.environment, "vpce", var.endpoint_config[count.index].application]))}" }
  )
}
