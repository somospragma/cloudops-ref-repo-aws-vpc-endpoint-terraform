###########################################
######## Local Transformations ############
###########################################

# PC-IAC-026: Patrón de Transformación en Root
# Flujo: terraform.tfvars → variables.tf → locals.tf → main.tf → module

locals {
  # Prefijo de gobernanza
  governance_prefix = "${var.client}-${var.project}-${var.environment}"
  
  # Transformación de vpc_endpoints con inyección de IDs dinámicos desde data sources
  vpc_endpoints_transformed = {
    for key, config in var.vpc_endpoints :
    key => merge(config, {
      # Inyectar VPC ID desde data source si está vacío
      vpc_id = length(config.vpc_id) > 0 ? config.vpc_id : data.aws_vpc.selected.id
      
      # Inyectar subnet IDs desde data source si está vacío
      subnet_ids = length(config.subnet_ids) > 0 ? config.subnet_ids : [
        for subnet in data.aws_subnets.private.ids : subnet
      ]
      
      # Inyectar security group IDs desde data source si está vacío
      security_group_ids = length(config.security_group_ids) > 0 ? config.security_group_ids : [
        data.aws_security_group.vpce.id
      ]
      
      # Inyectar route table IDs desde data source si está vacío
      route_table_ids = length(config.route_table_ids) > 0 ? config.route_table_ids : [
        for rt in data.aws_route_tables.private.ids : rt
      ]
    })
  }
}
