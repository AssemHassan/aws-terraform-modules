module "discovery" {
  source      = "./modules/discovery" 
   vpc_name_pattern = "${var.app.app_name}-VPC"
   container_role_name_pattern = "${var.app.app_name}_${var.app.env}_ecstaskexecution_role"
   ec2_role_name_pattern = "${var.app.app_name}_${var.app.env}_ec2_role"
   ec2_instance_profile_name_pattern = "${var.app.app_name}_${var.app.env}_ec2_instance_profile"
   batch_service_role_name_pattern = "AWSServiceRoleForBatch"
   lambda_role_name_pattern = "${var.app.app_name}_${var.app.env}_lambda_role"
   sg_name_pattern = "SG-${var.app.app_name}-CUSTOM"
   container_subnets_name_pattern = "Private*-Containers"
   lambda_subnets_name_pattern = "Private*-Serverless"
}



# module "lambda" {
#   source = "./modules/lambda/lambda-pingo"
#   namespace = var.app.app_name
#   lambda_role_arn = module.discovery.lambda_role.arn
# }

# module "longrun-demo" {
#   #wrong approach test module - just for demo
#   source = "./modules/lambda/lambda-gw-longrun-demo"
#   namespace = var.app.app_name
#   lambda_role_arn = module.discovery.lambda_role.arn
# }

module "fg-cluster" {
   source = "./modules/fg-cluster"
   namespace = var.app.app_name 
   container_host_port = 80 #world
   container_port = 80 #internal
   ecs_task_execution_role_arn = module.discovery.container_role.arn
   ecs_task_role_arn = module.discovery.container_role.arn
   container_image = "public.ecr.aws/nginx/nginx:1.24-alpine-slim"
}

locals {
  domain_name = "${var.app.app_name}.myit"
}

module "self-signed-cert-non-prod" {
  source = "./modules/self-signed-cert-non-prod"
  domain_name =local.domain_name
  
}


module "cognito-user-pool" {
  source = "./modules/cognito-userpool"
  namespace = var.app.app_name
  env       = var.app.env
}

module "cognito-appclient" {
  source          = "./modules/cognito-app"
  user_pool_id    = module.cognito-user-pool.user_pool.id
  namespace = var.app.app_name
  app_client_list = [
    {
      env_name      = "dev"
      signout_urls  = ["http://localhost:8080/signout.html", "https://localhost:8081/signout.html", "https://${local.domain_name}/signout.html"]
      callback_urls = ["http://localhost:8080/index.html", "https://localhost:8081/index.html", "https://${local.domain_name}/index.html"]
    }]
}


module "elb-fargate-service" {
  source = "./modules/elb-fargate-service"
  namespace = var.app.app_name
  ecs_cluster = module.fg-cluster.main_cluster
  service-taskDefinition = module.fg-cluster.service-taskDefinition
  container_host_port = 80
  container_port = 80
  container_subnets = module.discovery.container_subnets.ids
  security_groups = [module.discovery.default_sg]
  vpc_id = module.discovery.vpc_id 
  health_check_path = "/"
  cognito_user_pool_arn = module.cognito-user-pool.user_pool.arn
  cognito_user_pool_domain = module.cognito-user-pool.user_pool.domain
  cognito_user_pool_client_id = module.cognito-appclient.userpool_clients.dev.id

  cert_arn = module.self-signed-cert-non-prod.cert_arn
}

# module "batch-jobs" {
#   source = "./modules/batch-jobs"
#   namespace = var.app.app_name
#   ecs_task_execution_role_arn = module.discovery.ec2_role.arn
#   ecs_task_role_arn = module.discovery.ec2_instance_profile.arn
#   batch_service_role_arn = module.discovery.batch_service_role.arn
   
#   container_image = "nginx:latest"  
#   security_groups = [module.discovery.default_sg]
#   container_subnets = module.discovery.container_subnets.ids
# }

