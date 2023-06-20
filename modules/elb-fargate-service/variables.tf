variable "namespace" {
    type = string
}
variable "ecs_cluster" {}
variable "service-taskDefinition" {} 

variable "servicename" {
  type = string
  default = "service"
}
  

variable "container_port" {
     type = number 
}

variable "container_host_port" {
     type = number 
}
 

variable "container_subnets" {
  type = list
}

variable "health_check_path" {
  type = string
}

variable "security_groups" {
  type = list
}

variable "vpc_id" {
  type = string
}

variable "cert_arn" {
  type = string
}

variable "cognito_user_pool_arn" {
  type = string
}
variable "cognito_user_pool_client_id" {
  type = string
}
variable "cognito_user_pool_domain" {
  type = string
}

variable "container_name" {
  type = string
}
