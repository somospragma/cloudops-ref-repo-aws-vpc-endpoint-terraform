###########################################
######### VPC Endpoint module #############
###########################################

# PC-IAC-026: SOLO invocar módulo con local.* (nunca var.* directos)
# PROHIBIDO: Contener bloques locals {} aquí

module "vpc_endpoints" {
  source = "../../"
  
  providers = {
    aws.project = aws.principal
  }

  # Common configuration
  client      = var.client
  project     = var.project
  environment = var.environment

  # ✅ Consumir local transformado (PC-IAC-026)
  # Los IDs dinámicos ya fueron inyectados en locals.tf
  vpc_endpoints = local.vpc_endpoints_transformed
}
