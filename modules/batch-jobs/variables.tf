variable "namespace" {
    type = string
}
 
variable "ecs_task_execution_role_arn" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}

variable "batch_service_role_arn" {
  type = string
} 
  
variable "container_image" {
  type = string
}

variable "container_subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list
}