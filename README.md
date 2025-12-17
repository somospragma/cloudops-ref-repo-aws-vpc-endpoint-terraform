# Módulo Terraform: cloudops-ref-repo-aws-vpc-endpoint-terraform

## 📋 Descripción

Este módulo facilita la creación de VPC Endpoints en AWS siguiendo las mejores prácticas de seguridad y gobernanza. Soporta los tres tipos de endpoints:
- **Gateway**: Para S3 y DynamoDB
- **Interface**: Para la mayoría de servicios AWS
- **GatewayLoadBalancer**: Para appliances de terceros

El módulo está diseñado siguiendo las **26 Reglas de Gobernanza PC-IAC** para garantizar consistencia, seguridad y mantenibilidad.

## ✨ Características

- ✅ **For_Each Implementation**: Gestión granular de recursos individuales
- ✅ **Nomenclatura Centralizada**: Nombres consistentes usando patrón estándar
- ✅ **Validaciones de Entrada**: Validación de tipos de endpoint y variables de gobernanza
- ✅ **Outputs Granulares**: Exposición de IDs, ARNs, DNS entries y más
- ✅ **Hardenizado de Seguridad**: Aplicación condicional de security groups según tipo
- ✅ **Tagging Automático**: Tags de gobernanza aplicados automáticamente
- ✅ **Provider Injection**: Soporte para múltiples cuentas AWS

## 📁 Estructura del Módulo

```
cloudops-ref-repo-aws-vpc-endpoint-terraform/
├── .gitignore
├── CHANGELOG.md
├── README.md
├── catalog-info.yaml
├── data.tf                 # Comentario sobre data sources en Root
├── locals.tf               # Nomenclatura y transformaciones
├── main.tf                 # Recursos VPC Endpoint
├── outputs.tf              # Outputs granulares
├── providers.tf            # Comentario sobre provider injection
├── variables.tf            # Variables con validaciones
├── versions.tf             # Requisitos de versión
└── sample/
    ├── README.md
    ├── data.tf             # Data sources para IDs dinámicos
    ├── locals.tf           # Transformaciones PC-IAC-026
    ├── main.tf             # Invocación del módulo
    ├── outputs.tf          # Outputs del ejemplo
    ├── providers.tf        # Configuración del provider
    ├── terraform.tfvars.sample
    └── variables.tf
```

## 🔧 Requisitos Previos

Este módulo requiere los siguientes recursos previamente creados:

- **VPC ID**: La VPC donde se crearán los endpoints
- **Security Group IDs**: Para Interface endpoints (opcional si se usa default)
- **Subnet IDs**: Para Interface y GatewayLoadBalancer endpoints
- **Route Table IDs**: Para Gateway endpoints

## 📦 Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.31.0 |

## 🔌 Providers

| Name | Version | Alias |
|------|---------|-------|
| aws.project | >= 4.31.0 | Inyectado desde Root |

## 📥 Inputs

### Variables de Gobernanza (Obligatorias)

| Name | Description | Type | Validation | Required |
|------|-------------|------|------------|:--------:|
| client | Client name | `string` | Lowercase, numbers, hyphens | yes |
| project | Project name | `string` | Lowercase, numbers, hyphens | yes |
| environment | Environment | `string` | dev, qa, uat, prod, sandbox | yes |

### Variables de Configuración

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_endpoints | Map of VPC Endpoints configuration | `map(object)` | n/a | yes |

#### Estructura de `vpc_endpoints`

```hcl
vpc_endpoints = {
  "endpoint-key" = {
    vpc_id              = string                    # Required
    service_name        = string                    # Required
    vpc_endpoint_type   = string                    # Required: Gateway, Interface, GatewayLoadBalancer
    private_dns_enabled = optional(bool, false)     # Optional
    security_group_ids  = optional(list(string), [])# Optional
    subnet_ids          = optional(list(string), [])# Optional
    route_table_ids     = optional(list(string), [])# Optional
  }
}
```

## 📤 Outputs

| Name | Description | Type |
|------|-------------|------|
| vpc_endpoint_ids | Map of VPC Endpoint IDs | `map(string)` |
| vpc_endpoint_arns | Map of VPC Endpoint ARNs | `map(string)` |
| vpc_endpoint_dns_entries | Map of DNS entries (Interface endpoints) | `map(list)` |
| vpc_endpoint_network_interface_ids | Map of Network Interface IDs | `map(list)` |
| vpc_endpoint_state | Map of endpoint states | `map(string)` |
| vpc_endpoint_info | Complete endpoint information | `map(object)` |

## 🚀 Uso del Módulo

### Ejemplo Básico

```hcl
module "vpc_endpoints" {
  source = "git::https://github.com/org/cloudops-ref-repo-aws-vpc-endpoint-terraform.git?ref=v2.0.0"
  
  providers = {
    aws.project = aws.principal
  }

  # Gobernanza
  client      = "cliente01"
  project     = "proyecto01"
  environment = "dev"

  # VPC Endpoints
  vpc_endpoints = {
    "s3" = {
      vpc_id            = "vpc-xxx"
      service_name      = "com.amazonaws.us-east-1.s3"
      vpc_endpoint_type = "Gateway"
      route_table_ids   = ["rtb-xxx", "rtb-yyy"]
    }
    
    "eks" = {
      vpc_id              = "vpc-xxx"
      service_name        = "com.amazonaws.us-east-1.eks"
      vpc_endpoint_type   = "Interface"
      private_dns_enabled = true
      security_group_ids  = ["sg-xxx"]
      subnet_ids          = ["subnet-xxx", "subnet-yyy"]
    }
  }
}
```

### Ejemplo para EKS (Completo)

```hcl
module "vpc_endpoints_eks" {
  source = "git::https://github.com/org/cloudops-ref-repo-aws-vpc-endpoint-terraform.git?ref=v2.0.0"
  
  providers = {
    aws.project = aws.principal
  }

  client      = "mycompany"
  project     = "eks-cluster"
  environment = "prod"

  vpc_endpoints = {
    # Gateway Endpoints (sin costo)
    "s3" = {
      vpc_id            = var.vpc_id
      service_name      = "com.amazonaws.${var.aws_region}.s3"
      vpc_endpoint_type = "Gateway"
      route_table_ids   = var.private_route_table_ids
    }
    
    "dynamodb" = {
      vpc_id            = var.vpc_id
      service_name      = "com.amazonaws.${var.aws_region}.dynamodb"
      vpc_endpoint_type = "Gateway"
      route_table_ids   = var.private_route_table_ids
    }
    
    # Interface Endpoints (con costo)
    "eks" = {
      vpc_id              = var.vpc_id
      service_name        = "com.amazonaws.${var.aws_region}.eks"
      vpc_endpoint_type   = "Interface"
      private_dns_enabled = true
      security_group_ids  = [var.vpce_security_group_id]
      subnet_ids          = var.private_subnet_ids
    }
    
    "ecr-api" = {
      vpc_id              = var.vpc_id
      service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
      vpc_endpoint_type   = "Interface"
      private_dns_enabled = true
      security_group_ids  = [var.vpce_security_group_id]
      subnet_ids          = var.private_subnet_ids
    }
    
    "ecr-dkr" = {
      vpc_id              = var.vpc_id
      service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
      vpc_endpoint_type   = "Interface"
      private_dns_enabled = true
      security_group_ids  = [var.vpce_security_group_id]
      subnet_ids          = var.private_subnet_ids
    }
    
    "ec2" = {
      vpc_id              = var.vpc_id
      service_name        = "com.amazonaws.${var.aws_region}.ec2"
      vpc_endpoint_type   = "Interface"
      private_dns_enabled = true
      security_group_ids  = [var.vpce_security_group_id]
      subnet_ids          = var.private_subnet_ids
    }
    
    "sts" = {
      vpc_id              = var.vpc_id
      service_name        = "com.amazonaws.${var.aws_region}.sts"
      vpc_endpoint_type   = "Interface"
      private_dns_enabled = true
      security_group_ids  = [var.vpce_security_group_id]
      subnet_ids          = var.private_subnet_ids
    }
    
    "logs" = {
      vpc_id              = var.vpc_id
      service_name        = "com.amazonaws.${var.aws_region}.logs"
      vpc_endpoint_type   = "Interface"
      private_dns_enabled = true
      security_group_ids  = [var.vpce_security_group_id]
      subnet_ids          = var.private_subnet_ids
    }
  }
}
```

## 🔒 Seguridad & Cumplimiento

### Escaneo de Seguridad

| Benchmark | Date | Version | Status |
| --------- | ---- | ------- | ------ |
| ![checkov](https://img.shields.io/badge/checkov-passed-green) | 2024-12-17 | 3.2.232 | ✅ Passed |

### Mejores Prácticas Implementadas

- ✅ **Private DNS Enabled**: Para Interface endpoints (cuando aplica)
- ✅ **Security Groups**: Aplicados condicionalmente según tipo de endpoint
- ✅ **Subnet Isolation**: Endpoints en subnets privadas
- ✅ **Least Privilege**: Solo los permisos necesarios
- ✅ **Tagging**: Tags de gobernanza automáticos

## 📊 Cumplimiento PC-IAC

Este módulo cumple con las **26 Reglas de Gobernanza PC-IAC**. A continuación, las reglas más críticas aplicadas:

| Regla | Descripción | Implementación |
|-------|-------------|----------------|
| **PC-IAC-001** | Estructura de Módulo | ✅ 10 archivos raíz + 8 archivos sample/ |
| **PC-IAC-002** | Variables con Validaciones | ✅ Validaciones en client, project, environment, vpc_endpoint_type |
| **PC-IAC-003** | Nomenclatura Estándar | ✅ Centralizada en `locals.tf`: `{client}-{project}-{environment}-vpce-{key}` |
| **PC-IAC-005** | Provider Injection | ✅ Alias `aws.project` inyectado desde Root |
| **PC-IAC-006** | Versiones Fijadas | ✅ `versions.tf` con Terraform >= 1.0, AWS >= 4.31.0 |
| **PC-IAC-007** | Outputs Granulares | ✅ 6 outputs con IDs, ARNs, DNS, NICs, state, info completa |
| **PC-IAC-009** | Tipos de Datos | ✅ `map(object)` para vpc_endpoints con optional() |
| **PC-IAC-010** | For_Each Obligatorio | ✅ `for_each` en `aws_vpc_endpoint.this` |
| **PC-IAC-011** | Data Sources en Root | ✅ `data.tf` con comentario, data sources en sample/ |
| **PC-IAC-012** | Locals para Transformaciones | ✅ `locals.tf` con nomenclatura y tags comunes |
| **PC-IAC-020** | Hardenizado de Seguridad | ✅ Aplicación condicional de SGs, subnets, route tables según tipo |
| **PC-IAC-026** | Patrón de Transformación | ✅ sample/ sigue flujo: tfvars → data → locals → main → module |

### Decisiones de Diseño

#### 1. Cambio de `list(object)` a `map(object)`
**Razón**: Permite gestión granular con `for_each` y facilita referencias por clave.

**Antes (v1.x)**:
```hcl
endpoint_config = [
  { application = "s3", ... }
]
```

**Después (v2.x)**:
```hcl
vpc_endpoints = {
  "s3" = { ... }
}
```

#### 2. Aplicación Condicional de Atributos
**Razón**: Cada tipo de endpoint requiere diferentes atributos.

```hcl
# Security groups solo para Interface
security_group_ids = each.value.vpc_endpoint_type == "Interface" ? each.value.security_group_ids : null

# Subnets para Interface y GatewayLoadBalancer
subnet_ids = contains(["Interface", "GatewayLoadBalancer"], each.value.vpc_endpoint_type) ? each.value.subnet_ids : null

# Route tables solo para Gateway
route_table_ids = each.value.vpc_endpoint_type == "Gateway" ? each.value.route_table_ids : null
```

#### 3. Nomenclatura Dinámica
**Razón**: Consistencia y trazabilidad en toda la infraestructura.

```hcl
# locals.tf
vpc_endpoint_names = {
  for key, config in var.vpc_endpoints :
  key => "${local.governance_prefix}-vpce-${key}"
}

# Resultado: cliente01-proyecto01-dev-vpce-s3
```

#### 4. Patrón de Transformación en Sample (PC-IAC-026)
**Razón**: Separación de responsabilidades y reutilización de código.

```
terraform.tfvars (config declarativa)
    ↓
data.tf (obtener IDs dinámicos)
    ↓
locals.tf (inyectar IDs en config)
    ↓
main.tf (invocar módulo con local.*)
```

## 📚 Recursos Creados

| Resource | Type |
|----------|------|
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |

## 🔄 Migración desde v1.x

Ver [CHANGELOG.md](./CHANGELOG.md) para guía completa de migración.

**Cambios principales**:
1. Variable `endpoint_config` → `vpc_endpoints`
2. Tipo `list(object)` → `map(object)`
3. Campo `application` → clave del map
4. Campo `enable` → usar map condicional
5. Resource `aws_vpc_endpoint.endpoint` → `aws_vpc_endpoint.this`

## 🧪 Testing

```bash
# Validar sintaxis
terraform validate

# Formatear código
terraform fmt -recursive

# Escaneo de seguridad
checkov -d .

# Plan de ejemplo
cd sample/vpce
terraform init
terraform plan
```

## 📖 Referencias

- [AWS VPC Endpoints Documentation](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints.html)
- [Terraform AWS Provider - VPC Endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint)
- [AWS PrivateLink Pricing](https://aws.amazon.com/privatelink/pricing/)
- [EKS VPC Endpoints Requirements](https://docs.aws.amazon.com/eks/latest/userguide/private-clusters.html)

## 📝 Changelog

Ver [CHANGELOG.md](./CHANGELOG.md) para el historial completo de cambios.

## 👥 Autores

CloudOps Team

## 📄 Licencia

Proprietary - Todos los derechos reservados
