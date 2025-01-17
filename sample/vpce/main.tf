###########################################
######### VPC Endpoint module #############
###########################################

module "vpc_endpoints" {
  source = "../../"
  providers = {
    aws.project = aws.alias01              #Write manually alias (the same alias name configured in providers.tf)
  }

  # Common configuration
  client      = var.client
  project     = var.project
  environment = var.environment

  # VPC Endpoint configuration
  endpoint_config = [
    #DynamoDB Endpoint (Gateway type)
    {
      vpc_id              = module.vpc.vpc_id
      service_name        = "com.amazonaws.us-east-1.dynamodb"
      vpc_endpoint_type   = "Gateway"
      private_dns_enabled = false
      security_group_ids  = []
      subnet_ids          = []
      route_table_ids     = [module.vpc.route_table_ids["private"], module.vpc.route_table_ids["service"], module.vpc.route_table_ids["database"]]
      application         = "dynamodb"
    },
    #S3 Endpoint (Gateway type)
    {
      vpc_id              = module.vpc.vpc_id
      service_name        = "com.amazonaws.us-east-1.s3"
      vpc_endpoint_type   = "Gateway"
      private_dns_enabled = false
      security_group_ids  = []
      subnet_ids          = []
      route_table_ids     = [module.vpc.route_table_ids["private"], module.vpc.route_table_ids["service"], module.vpc.route_table_ids["database"]]
      application         = "s3"
    },
    #SM Endpoint (Interface type)
    {
      vpc_id              = module.vpc.vpc_id
      service_name        = "com.amazonaws.us-east-1.sm"
      vpc_endpoint_type   = "Interface"
      private_dns_enabled = true
      security_group_ids  = [module.security_groups.sg_info["sm"].sg_id]
      subnet_ids          = [module.vpc.subnet_ids["private-0"], module.vpc.subnet_ids["private-0"], ]
      route_table_ids     = []
      application         = "sm"
    }
  ]
  depends_on = [module.security_groups, module.vpc]
}
