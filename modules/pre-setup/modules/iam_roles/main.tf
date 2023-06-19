 
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name}_${var.env}_ecstaskexecution_role"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.name}_${var.env}_lambda_role"
 
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role" "ec2_role" {
  name = "${var.name}_${var.env}_ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attachment01" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.name}_${var.env}_ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}
 
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment01" {
    role       = aws_iam_role.ecs_task_execution_role.name
    policy_arn = aws_iam_policy.dynamodb_access.arn
}
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment02" {
    role       = aws_iam_role.ecs_task_execution_role.name
    policy_arn = aws_iam_policy.ecr_access.arn
}
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment03" {
    role       = aws_iam_role.ecs_task_execution_role.name
    policy_arn = aws_iam_policy.elb_access.arn
}
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment04" {
    role       = aws_iam_role.ecs_task_execution_role.name
    policy_arn = aws_iam_policy.kms_access.arn
}
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment05" {
    role       = aws_iam_role.ecs_task_execution_role.name
    policy_arn = aws_iam_policy.lambda_access.arn
}
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment06" {
    role       = aws_iam_role.ecs_task_execution_role.name
    policy_arn = aws_iam_policy.s3_access.arn
}
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment07" {
    role       = aws_iam_role.ecs_task_execution_role.name
    policy_arn = aws_iam_policy.secretsmanager_access.arn
}
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment08" {
    role       = aws_iam_role.ecs_task_execution_role.name
    policy_arn = aws_iam_policy.sns_sqs_access.arn
}
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment09" {
    role       = aws_iam_role.ecs_task_execution_role.name
    policy_arn = aws_iam_policy.ssm_access.arn
}
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment10" {
    role       = aws_iam_role.ecs_task_execution_role.name
    policy_arn = aws_iam_policy.cloudwatch_access.arn
}


resource "aws_iam_role_policy_attachment" "lambda-role-policy-attachment01" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.dynamodb_access.arn
}
resource "aws_iam_role_policy_attachment" "lambda-role-policy-attachment02" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.ecr_access.arn
}
resource "aws_iam_role_policy_attachment" "lambda-role-policy-attachment03" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.elb_access.arn
}
resource "aws_iam_role_policy_attachment" "lambda-role-policy-attachment04" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.kms_access.arn
}
resource "aws_iam_role_policy_attachment" "lambda-role-policy-attachment05" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.lambda_access.arn
}
resource "aws_iam_role_policy_attachment" "lambda-role-policy-attachment06" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.s3_access.arn
}
resource "aws_iam_role_policy_attachment" "lambda-role-policy-attachment07" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.secretsmanager_access.arn
}
resource "aws_iam_role_policy_attachment" "lambda-role-policy-attachment08" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.sns_sqs_access.arn
}
resource "aws_iam_role_policy_attachment" "lambda-role-policy-attachment09" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.ssm_access.arn
}
resource "aws_iam_role_policy_attachment" "lambda-role-policy-attachment10" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.cloudwatch_access.arn
}
