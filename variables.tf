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
}

variable "client" {
  type = string
}

variable "environment" {
  type = string
}

variable "project" {
  type = string
}