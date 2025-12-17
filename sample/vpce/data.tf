###########################################
######## Data Sources #####################
###########################################

# PC-IAC-011: Data Sources en el Root Module
# PC-IAC-026: Obtener IDs dinámicos para inyectar en locals.tf

# Obtener VPC por nomenclatura estándar
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.client}-${var.project}-${var.environment}-vpc"]
  }
}

# Obtener subnets privadas
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  
  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

# Obtener route tables privadas
data "aws_route_tables" "private" {
  vpc_id = data.aws_vpc.selected.id
  
  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

# Obtener security group para VPC Endpoints
data "aws_security_group" "vpce" {
  vpc_id = data.aws_vpc.selected.id
  
  filter {
    name   = "tag:Name"
    values = ["${var.client}-${var.project}-${var.environment}-sg-vpce"]
  }
}
