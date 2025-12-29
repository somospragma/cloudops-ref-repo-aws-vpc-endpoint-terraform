# VPC Endpoint Module - Sample Implementation

Este directorio contiene un ejemplo funcional completo del módulo VPC Endpoint siguiendo el **Patrón de Transformación PC-IAC-026**.

## 📋 Flujo de Configuración

```
terraform.tfvars → variables.tf → data.tf → locals.tf → main.tf → module
```

### 1. `terraform.tfvars`
Configuración declarativa sin IDs hardcodeados. Los valores vacíos (`""`, `[]`) se llenan automáticamente.

### 2. `data.tf`
Data sources para obtener IDs dinámicos:
- VPC por nomenclatura estándar
- Subnets privadas
- Route tables privadas
- Security groups para VPC Endpoints

### 3. `locals.tf`
Transformación de variables inyectando IDs desde data sources:
- Construcción de nomenclatura completa
- Inyección dinámica de vpc_id, subnet_ids, security_group_ids, route_table_ids

### 4. `main.tf`
Invocación del módulo usando **SOLO** `local.*` (nunca `var.*` directos)

## 🚀 Uso

### Prerrequisitos

Antes de ejecutar este ejemplo, asegúrate de tener:
- Una VPC con nomenclatura estándar: `{client}-{project}-{environment}-vpc`
- Subnets privadas con tag `Type = "private"`
- Route tables con tag `Type = "private"`
- Security group para VPC Endpoints: `{client}-{project}-{environment}-sg-vpce`

### Pasos de Ejecución

1. **Copiar y configurar variables:**
   ```bash
   cp terraform.tfvars.sample terraform.tfvars
   # Editar terraform.tfvars con tus valores
   ```

2. **Inicializar Terraform:**
   ```bash
   terraform init
   ```

3. **Validar configuración:**
   ```bash
   terraform validate
   ```

4. **Revisar plan:**
   ```bash
   terraform plan
   ```

5. **Aplicar cambios:**
   ```bash
   terraform apply
   ```

## 📝 Configuración de Ejemplo

El ejemplo incluye VPC Endpoints para EKS:
- **Gateway Endpoints**: S3, DynamoDB
- **Interface Endpoints**: EKS, ECR API, ECR DKR, EC2, STS, CloudWatch Logs

Todos los IDs se obtienen dinámicamente usando data sources y nomenclatura estándar.

## 🔒 Seguridad

- Private DNS habilitado para Interface endpoints
- Security groups aplicados automáticamente
- Subnets privadas para Interface endpoints
- Route tables configuradas para Gateway endpoints

## 🧹 Limpieza

Para destruir los recursos creados:
```bash
terraform destroy
```

## 📚 Referencias

- [Módulo VPC Endpoint](../)
- [Reglas PC-IAC](../../docs/pc-iac-rules.md)
- [AWS VPC Endpoints Documentation](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints.html)
