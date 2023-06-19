module "kms" {
  source = "./modules/kms"
  use_kms = false #actuall skip this module
}
 

module "iam_roles" {
  source = "./modules/iam_roles"
  name = var.app.app_name
  account_number = var.app.account_number
  env = var.app.env
  region = var.app.region  
  kms_arn = module.kms.kms_arn == null ? "*" : module.kms.kms 
}

module "s3" {
  source = "./modules/s3"
  name = var.app.app_name
  env =  var.app.env
  kms_arn = module.kms.kms_arn == null ? "*" : module.kms.kms 
}

data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = ["Main-VPC"]
  }
}

module "network" {
  source = "./modules/network"
  name = var.app.app_name
  env =  var.app.env
  region = var.app.region 
  vpc_cidr = "192.168.1.0/24"
}