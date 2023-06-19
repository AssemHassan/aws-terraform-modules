
variable "vpc_name_pattern" {
  type = string 
}

variable "sg_name_pattern" {
  type = string 
}

variable "container_subnets_name_pattern" {
  type = string 
}

variable "lambda_subnets_name_pattern" {
  type = string 
}

variable "container_role_name_pattern" {
  type = string 
}

variable "ec2_role_name_pattern" {
  type = string 
}

variable "ec2_instance_profile_name_pattern" {
  type  = string
}

variable "batch_service_role_name_pattern" {
  type  = string
}

variable "lambda_role_name_pattern" {
  type = string 
}

data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = [var.vpc_name_pattern]
  }
}

data "aws_subnets" "container_subnets" {
  filter {
    name = "tag:Name"
    values = [var.container_subnets_name_pattern]
  }
}

data "aws_subnets" "lambda_subnets" {
  filter {
    name = "tag:Name"
    values = [var.lambda_subnets_name_pattern]
  }
}

data "aws_iam_role" "container_role" {
   name = var.container_role_name_pattern
}

data "aws_iam_role" "ec2_role" {
   name = var.ec2_role_name_pattern
}

data "aws_iam_instance_profile" "ec2_instance_profile" {
   name = var.ec2_instance_profile_name_pattern
}

data "aws_iam_role" "batch_service_role" {
   name = var.batch_service_role_name_pattern
}

data "aws_iam_role" "lambda_role" {
   name = var.lambda_role_name_pattern
}


data "aws_security_group" "default_sg" {
   filter {
    name = "tag:Name"
    values = [var.sg_name_pattern]
  } 
}
 
 