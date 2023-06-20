variable "namespace" {
    type = string
}

variable "servicename" {
  type = string
  default = "service"
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}
 

variable "container_port" {
     type = number 
}

variable "container_host_port" {
     type = number 
}

variable "container_image" {
  type = string
} 

variable "container_name" {
  type = string
}