output "vpc_id" {
  value = data.aws_vpc.selected.id
}

output "container_subnets" {
  value = data.aws_subnets.container_subnets
}

output "lambda_subnets" {
  value = data.aws_subnets.lambda_subnets
}

output "container_role" {
  value = data.aws_iam_role.container_role
}

output "ec2_role" {
  value = data.aws_iam_role.ec2_role
}

output "ec2_instance_profile" {
  value = data.aws_iam_instance_profile.ec2_instance_profile
}

output "batch_service_role" {
  value = data.aws_iam_role.batch_service_role
}


output "lambda_role" {
  value = data.aws_iam_role.lambda_role
}


output "default_sg" {
  value = data.aws_security_group.default_sg
}
