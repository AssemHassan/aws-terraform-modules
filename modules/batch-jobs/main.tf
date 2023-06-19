# Create a job definition for our batch job
resource "aws_batch_job_definition" "job_def" {
  name                = "${var.namespace}-batch-job-def"
  type                = "container"
  container_properties = jsonencode({
    image             = var.container_image    
    vcpus             = 1
    memory            = 512 
  })
} 
# Create a compute environment for our batch job
resource "aws_batch_compute_environment" "comp_env" {
  compute_environment_name                  = "${var.namespace}-compute-environment"
  type                 = "MANAGED"
  service_role         = var.batch_service_role_arn 
  
  ## ecs_cluster is auto assigned upon creation and can't be assigned, we can't use an existing cluster, or at least it is tricky
  #ecs_cluster_arn      =  

  
  compute_resources {
    ## 4 following Attributes are supported in case of type = "EC2"
    #instance_role      = var.ecs_task_role_arn
    #instance_type      = ["a1.medium"]
    #min_vcpus          = 0
    #desired_vcpus      = 1

    max_vcpus          = 2
    subnets = var.container_subnets
    security_group_ids = var.security_groups.*.id
    type          = "FARGATE" #"EC2"
  }
}

#Create a job queue for our batch job
resource "aws_batch_job_queue" "job_queue" {
  name                      = "${var.namespace}-batch-job-queue"
  state                     = "ENABLED"
  priority                  = 1  
  compute_environments      = [aws_batch_compute_environment.comp_env.arn]
}
 
