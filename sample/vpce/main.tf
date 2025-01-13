################################################################
# Module VPC Endpoint 
################################################################
module "vpc_endpoints" {
  source = ""
  providers = {
    aws.project = aws.alias01
  }
  client      = var.client
  environment = var.environment
  project     = var.project

  endpoint_config = [
    # S3 Endpoint (Gateway type)
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

    # EC2 Endpoint (Interface type)
    {
      vpc_id              = module.vpc.vpc_id
      service_name        = "com.amazonaws.us-east-1.ec2"
      vpc_endpoint_type   = "Interface"
      private_dns_enabled = true
      security_group_ids  = [module.security_groups.sg_info["sm"].sg_id]
      subnet_ids          = [module.vpc.subnet_ids["private-0"], module.vpc.subnet_ids["private-0"], ]
      route_table_ids     = []
      application         = "ec2"
    },

    # DynamoDB Endpoint (Gateway type)
    {
      vpc_id              = module.vpc.vpc_id
      service_name        = "com.amazonaws.us-east-1.dynamodb"
      vpc_endpoint_type   = "Gateway"
      private_dns_enabled = false
      security_group_ids  = []
      subnet_ids          = []
      route_table_ids     = [module.vpc.route_table_ids["private"], module.vpc.route_table_ids["service"], module.vpc.route_table_ids["database"]]
      application         = "dynamodb"
    }
  ]
  depends_on = [module.security_groups, module.vpc]
}
