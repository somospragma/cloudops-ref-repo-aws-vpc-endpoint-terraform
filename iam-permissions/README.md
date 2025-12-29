# Permisos IAM Requeridos - Módulo VPC Endpoints

Este documento detalla los permisos IAM necesarios para desplegar y gestionar el módulo VPC Endpoints.

## 📋 Resumen de Permisos

Para desplegar este módulo, el usuario/rol de IAM necesita permisos para:

1. **VPC Endpoints** - Crear y gestionar VPC endpoints (Gateway e Interface)
2. **Network Interfaces** - Gestionar ENIs para Interface endpoints
3. **Security Groups** - Describir security groups
4. **Route Tables** - Describir route tables
5. **Tags** - Gestionar etiquetas en recursos

## 🔐 Política IAM Mínima

Usa la política personalizada en: [`vpc-endpoints-deployment-policy.json`](./vpc-endpoints-deployment-policy.json)

**Aplicar la política:**
```bash
# Crear la política
aws iam create-policy \
  --policy-name VPCEndpointsModuleDeploymentPolicy \
  --policy-document file://iam-permissions/vpc-endpoints-deployment-policy.json

# Adjuntar a un usuario
aws iam attach-user-policy \
  --user-name tu-usuario \
  --policy-arn arn:aws:iam::ACCOUNT-ID:policy/VPCEndpointsModuleDeploymentPolicy
```

## 📝 Permisos Detallados

### VPC Endpoints Management
```json
{
  "Effect": "Allow",
  "Action": [
    "ec2:CreateVpcEndpoint",
    "ec2:DeleteVpcEndpoints",
    "ec2:DescribeVpcEndpoints",
    "ec2:ModifyVpcEndpoint",
    "ec2:DescribeVpcEndpointServices",
    "ec2:DescribePrefixLists"
  ],
  "Resource": "*"
}
```

### Network Interfaces (for Interface Endpoints)
```json
{
  "Effect": "Allow",
  "Action": [
    "ec2:CreateNetworkInterface",
    "ec2:DeleteNetworkInterface",
    "ec2:DescribeNetworkInterfaces",
    "ec2:ModifyNetworkInterfaceAttribute"
  ],
  "Resource": "*"
}
```

## 🎯 Recursos Creados por el Módulo

Este módulo crea los siguientes recursos:

- ✅ N VPC Endpoints (Gateway o Interface según configuración)
- ✅ N Network Interfaces (para Interface endpoints)
- ✅ Tags en todos los recursos

## 💰 Costos Asociados

- **Gateway Endpoints** (S3, DynamoDB): Sin costo
- **Interface Endpoints**: ~$7.20/mes por endpoint + data transfer
- **Network Interfaces**: Sin costo adicional (incluido en Interface endpoint)

## 🔒 Mejores Prácticas

### 1. Limitar por Tipo de Endpoint
```json
{
  "Condition": {
    "StringEquals": {
      "ec2:VpceServiceName": "com.amazonaws.us-east-1.s3"
    }
  }
}
```

### 2. Limitar por VPC
```json
{
  "Condition": {
    "StringEquals": {
      "ec2:Vpc": "arn:aws:ec2:us-east-1:123456789012:vpc/vpc-xxxxx"
    }
  }
}
```

## 🆘 Troubleshooting

### Error: "User is not authorized to perform: ec2:CreateVpcEndpoint"
**Solución**: Adjuntar la política VPCEndpointsModuleDeploymentPolicy

### Error: "Service not available in this region"
**Solución**: Verificar que el servicio de AWS esté disponible en tu región

### Error: "Access Denied" al crear Interface endpoint
**Solución**: Verificar permisos `ec2:CreateNetworkInterface`

## 📚 Referencias

- [AWS VPC Endpoints Documentation](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints.html)
- [VPC Endpoints IAM](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints-iam.html)
