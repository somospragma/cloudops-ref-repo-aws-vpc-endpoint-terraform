# **Módulo Terraform: cloudops-ref-repo-aws-vpc-endpoint-terraform**

## Descripción:

Este módulo facilita la creación de un Virtual Private Cloud Endpoint completo en AWS.

Este módulo de Terraform para un VPC Endpoint de AWS necesitará de los siguientes recursos previamente creados:

- vpc_id: El ID de la VPC en la que se usará el punto final.
- security_group_ids: El ID de uno o más grupos de seguridad para asociar con la interfaz de red. Aplicable para puntos finales de tipo Interfaz. Si no se especifican grupos de seguridad, el grupo de seguridad predeterminado de la VPC se asocia con el punto final.
- subnet_ids: El ID de una o más subredes en las que se creará una interfaz de red para el punto final. Aplicable para puntos finales de tipo Gateway e Interfaz. Los puntos finales de tipo Interfaz no pueden funcionar sin estar asignados a una subred.
- route_table_ids: Uno o más ID de tabla de rutas. Aplicable para puntos finales de tipo Puerta de enlace.

Consulta CHANGELOG.md para la lista de cambios de cada versión. *Recomendamos encarecidamente que en tu código fijes la versión exacta que estás utilizando para que tu infraestructura permanezca estable y actualices las versiones de manera sistemática para evitar sorpresas.*

## Estructura del Módulo
El módulo cuenta con la siguiente estructura:

```bash
cloudops-ref-repo-aws-vpc-endpoint-terraform/
└── sample/
    ├── data.tf
    ├── main.tf
    ├── outputs.tf
    ├── providers.tf
    ├── terraform.tfvars.sample
    └── variables.tf
├── .gitignore
├── CHANGELOG.md
├── data.tf
├── main.tf
├── outputs.tf
├── providers.tf
├── README.md
├── variables.tf
```

- Los archivos principales del módulo (`data.tf`, `main.tf`, `outputs.tf`, `variables.tf`, `providers.tf`) se encuentran en el directorio raíz.
- `CHANGELOG.md` y `README.md` también están en el directorio raíz para fácil acceso.
- La carpeta `sample/` contiene un ejemplo de implementación del módulo.

## Seguridad & Cumplimiento
 
Consulta a continuación la fecha y los resultados de nuestro escaneo de seguridad y cumplimiento.

<!-- BEGIN_BENCHMARK_TABLE -->
| Benchmark | Date | Version | Description | 
| --------- | ---- | ------- | ----------- | 
| ![checkov](https://img.shields.io/badge/checkov-passed-green) | 2023-09-20 | 3.2.232 | Escaneo profundo del plan de Terraform en busca de problemas de seguridad y cumplimiento |
<!-- END_BENCHMARK_TABLE -->
 
## Provider Configuration

Este módulo requiere la configuración de un provider específico para el proyecto. Debe configurarse de la siguiente manera:

```hcl
sample/vpc/providers.tf
provider "aws" {
  alias = "alias01"
  # ... otras configuraciones del provider
}

sample/vpc/main.tf
module "vpc" {
  source = ""
  providers = {
    aws.project = aws.alias01
  }
  # ... resto de la configuración
}
```

## Uso del Módulo:

```hcl
module "vpc" {
  source = ""
  
  providers = {
    aws.project = aws.project
  }

# Common configuration 
profile     = "profile01"
aws_region  = "us-east-1"
environment = "dev"
client      = "cliente01"
project     = "proyecto01"
common_tags = {
  environment   = "dev"
  project-name  = "proyecto01"
  cost-center   = "xxx"
  owner         = "xxx"
  area          = "xxx"
  provisioned   = "xxx"
  datatype      = "xxx"
}

# VPC Endpoint configuration
endpoint_config =  [
    # DynamoDB Endpoint (Gateway type)
    {
      vpc_id              = "vpc-xxx"
      service_name        = "com.amazonaws.us-east-1.dynamodb"
      vpc_endpoint_type   = "Gateway"
      private_dns_enabled = false
      security_group_ids  = []  
      subnet_ids          = []  
      route_table_ids     = ["rtb-xxxx", "rtb-xxxx"]
      application         = "dynamodb"
    },
    # S3 Endpoint (Gateway type)
    {
      vpc_id              = "vpc-xxx"
      service_name        = "com.amazonaws.us-east-1.s3"
      vpc_endpoint_type   = "Gateway"
      private_dns_enabled = false
      security_group_ids  = []  
      subnet_ids          = []  
      route_table_ids     = ["rtb-xxxxx", "rtb-xxxxx"]
      application         = "s3"
    },
    # SM Endpoint (Interface type)
    {
      vpc_id              = "vpc-xxx"
      service_name        = "com.amazonaws.us-east-1.sm"
      vpc_endpoint_type   = "Interface"
      private_dns_enabled = true
      security_group_ids  = ["sg-xx"]
      subnet_ids          = ["subnet-xx", "subnet-xx"]
      route_table_ids     = []  
      application         = "sm"
    }
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.project"></a> [aws.project](#provider\_aws) | >= 4.31.0 |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="enable"></a> [enable](#input\_enable_) | Habilita o no la creación del vpce | `string` | n/a | yes |
| <a name="application"></a> [application](#input\_application_) | Nombre de la aplicación | `string` | n/a | yes |
| <a name="vpc_id"></a> [vpc_id](#input\_vpc_id) | Id de la VPC | `string` | n/a | yes |
| <a name="service_name"></a> [service_name](#input\_service_name) | Nombre del servicio | `string` | n/a | yes |
| <a name="vpc_endpoint_type"></a> [vpc_endpoint_type](#input\_vpc_endpoint_type) | Tipo de punto de conexión de la VPC | `string` | n/a | yes |
| <a name="private_dns_enabled"></a> [private_dns_enabled](#input\_private_dns_enabled) | DNS privado habilitado | `string` | n/a | yes |
| <a name="security_group_ids"></a> [security_group_ids](#input\_security_group_ids) | IDs de los grupos de seguridad| `string` | n/a | yes |
| <a name="subnet_ids"></a> [subnet_ids](#input\_subnet_ids) | IDs de las subredes| `string` | n/a | yes |
| <a name="route_table_ids"></a> [route_table_ids](#input\_route_table_ids) | IDs de las tablas de rutas| `string` | n/a | yes |
