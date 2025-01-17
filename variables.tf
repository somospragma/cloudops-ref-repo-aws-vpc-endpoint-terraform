###########################################
########## Common variables ###############
###########################################

variable "environment" {
  type = string
  description = "Environment where resources will be deployed"
}

variable "client" {
  type = string
  description = "Client name"
}

variable "project" {
  type = string  
    description = "Project name"
}

###########################################
####### VPC Endpoint variables ############
###########################################

variable "endpoint_config" {
  type = list(object({
    enable = optional(bool, true)
    vpc_id = string
    service_name = string
    vpc_endpoint_type = string
    private_dns_enabled = bool
    security_group_ids = list(string)
    subnet_ids = list(string)
    route_table_ids = list(string)
    application = string
  }))
  description = <<EOF
    - enable: (boolean, optional) The flag indicates if a vpce will be created or not.
    - vpc_id: (string) The ID of the VPC in which the endpoint will be used.
    - service_name: (string) The service name. For AWS services the service name is usually in the form com.amazonaws.<region>.<service>
    - vpc_endpoint_type: (string) The VPC endpoint type, Gateway, GatewayLoadBalancer, or Interface. Defaults to Gateway.
    - private_dns_enabled: (bool) AWS services and AWS Marketplace partner services only. Whether or not to associate a private hosted zone with the specified VPC. Applicable for endpoints of type Interface. Most users will want this enabled to allow services within the VPC to automatically use the endpoint. Defaults to false.
    - security_group_ids: (list(string)) The ID of one or more security groups to associate with the network interface. Applicable for endpoints of type Interface. If no security groups are specified, the VPC's default security group is associated with the endpoint.
    - subnet_ids: (list(string)) The ID of one or more subnets in which to create a network interface for the endpoint. Applicable for endpoints of type GatewayLoadBalancer and Interface. Interface type endpoints cannot function without being assigned to a subnet.
    - route_table_ids: (list(string)) One or more route table IDs. Applicable for endpoints of type Gateway.
    - application: (string) Application name in order to name vpc-endpoint
  EOF
}