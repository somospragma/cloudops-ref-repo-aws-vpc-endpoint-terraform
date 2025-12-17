###########################################
######## Local Variables ##################
###########################################

# PC-IAC-003: Nomenclatura Estándar Centralizada
# PC-IAC-012: Estructuras de Datos y Reutilización

locals {
  # Prefijo de gobernanza estándar
  governance_prefix = "${var.client}-${var.project}-${var.environment}"
  
  # Construcción de nombres para VPC Endpoints
  # Formato: {client}-{project}-{environment}-vpce-{key}
  vpc_endpoint_names = {
    for key, config in var.vpc_endpoints :
    key => "${local.governance_prefix}-vpce-${key}"
  }
  
  # Tags comunes para todos los recursos
  common_tags = {
    Client      = var.client
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
    Module      = "cloudops-ref-repo-aws-vpc-endpoint-terraform"
  }
}
