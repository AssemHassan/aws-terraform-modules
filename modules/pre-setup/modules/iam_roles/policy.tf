


resource "aws_iam_policy" "kms_access" {
  name        = "${var.name}-_${var.env}_kms_access"
  description = "Policy that allows access to KMS"
 
 policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey",
                "kms:DescribeKey"
            ],
            "Resource": [
                "${var.kms_arn}"
            ],
            "Effect": "Allow",
            "Sid": "AllowUstoAccessKMS"
        }
    ]
}
)
}

resource "aws_iam_policy" "s3_access" {
  name        = "${var.name}-_${var.env}_s3_access"
  description = "Policy that allows access to S3"
 
 policy = jsonencode(
 {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:ListAllMyBuckets"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "ListingBuckets"
        },
        {
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::us.com.syngenta.${var.name}.${var.env}*"
            ],
            "Effect": "Allow",
            "Sid": "ListingObjects"
        },
        {
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::us.com.syngenta.${var.name}.${var.env}*",
                "arn:aws:s3:::us.com.syngenta.${var.name}.${var.env}*/*"
            ],
            "Effect": "Allow",
            "Sid": "BoundedByNamespace"
        },
        {
            "Action": [
                "s3:ReplicateTags",
                "s3:DeleteBucket",
                "s3:PutBucketPublicAccessBlock",
                "s3:PutBucketWebsite",
                "s3:PutBucketPolicy",
                "s3:DeleteBucketPolicy"
            ],
            "Resource": "*",
            "Effect": "Deny",
            "Sid": "DenyStatement"
        }
    ]
}
)
}

resource "aws_iam_policy" "lambda_access" {
  name        = "${var.name}-_${var.env}_lambda_access"
  description = "Policy that allows access to LAMBDA"
 
 policy = jsonencode(
 {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "lambda:Get*",
                "lambda:List*",
                "sqs:*"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "UniversalAllow"
        },
        {
            "Action": [
                "lambda:*"
            ],
            "Resource": [
                "arn:aws:lambda:${var.region}:${var.account_number}:function:${var.name}*",
                "arn:aws:lambda:${var.region}:${var.account_number}:layer:${var.name}*",
                "arn:aws:lambda:${var.region}:${var.account_number}:layer:${var.name}*:*"
            ],
            "Effect": "Allow",
            "Sid": "BoundedByNamespace"
        },
        {
            "Condition": {
                "StringLike": {
                    "lambda:FunctionArn": [
                        "arn:aws:lambda:${var.region}:${var.account_number}:function:${var.name}*"
                    ]
                }
            },
            "Action": [
                "lambda:CreateEventSourceMapping",
                "lambda:UpdateEventSourceMapping",
                "lambda:DeleteEventSourceMapping"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "EventSourceMappingBoundedByNamespace"
        },
        {
            "Action": [
                "cloudformation:DescribeResources",
                "iam:ListRoles",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:ListRolePolicies",
                "ec2:Describe*",
                "kms:ListAliases"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "OtherPermissions"
        }
    ]
}
)
}

resource "aws_iam_policy" "secretsmanager_access" {
  name        = "${var.name}-_${var.env}_secretsmanager_access"
  description = "Policy that allows access to SecretsManager"
 
 policy = jsonencode(
 {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "secretsmanager:GetRandomPassword",
                "secretsmanager:ListSecrets",
                "rds:DescribeDBClusters",
                "rds:DescribeDBInstances",
                "redshift:DescribeClusters"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "UniversalAllow"
        },
        {
            "Action": [
                "secretsmanager:*"
            ],
            "Resource": [
                "arn:aws:secretsmanager:${var.region}:${var.account_number}:secret:${var.name}*"
            ],
            "Effect": "Allow",
            "Sid": "BoundedByNamespace"
        }
    ]
} 
)
}

resource "aws_iam_policy" "sns_sqs_access" {
  name        = "${var.name}-_${var.env}_sns_sqs_access"
  description = "Policy that allows access to sns_sqs"
 
 policy = jsonencode(
 {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sns:ListTopics",
                "sns:ListSubscriptions"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "UniversalAllowSNS"
        },
        {
            "Action": [
                "sns:*"
            ],
            "Resource": [
                "arn:aws:sns:${var.region}:${var.account_number}:${var.name}*"
            ],
            "Effect": "Allow",
            "Sid": "BoundedByNamespaceSNS"
        },
        {
            "Action": [
                "sqs:ListQueues",
                "sqs:GetQueueAttributes"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "UniversalAllowSQS"
        },
        {
            "Action": [
                "sqs:*"
            ],
            "Resource": [
                "arn:aws:sqs:${var.region}:${var.account_number}:${var.name}*"
            ],
            "Effect": "Allow",
            "Sid": "BoundedByNamespaceSQS"
        }
    ]
}
)
}

resource "aws_iam_policy" "ssm_access" {
  name        = "${var.name}-_${var.env}_ssm_access"
  description = "Policy that allows access to SSM"
 
 policy = jsonencode(
 {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ssm:DescribeParameters",
                "kms:ListAliases"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "UniversalAllow"
        },
        {
            "Action": [
                "ssm:PutParameter",
                "ssm:DeleteParameter",
                "ssm:GetParameterHistory",
                "ssm:ListTagsForResource",
                "ssm:GetParametersByPath",
                "ssm:GetParameters",
                "ssm:GetParameter",
                "ssm:ListTagsForResource",
                "ssm:DeleteParameters"
            ],
            "Resource": [
                "arn:aws:ssm:${var.region}:${var.account_number}:parameter/${var.name}*"
            ],
            "Effect": "Allow",
            "Sid": "BoudedByNamespace"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        }
    ]
}
)
}

resource "aws_iam_policy" "elb_access" {
  name        = "${var.name}-_${var.env}_elb_access"
  description = "Policy that allows access to ELB"
 
 policy = jsonencode(
 {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "elasticloadbalancing:SetWebAcl",
                "elasticloadbalancing:Describe*",
                "ec2:Describe*"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "UniversalAllow"
        },
        {
            "Action": [
                "elasticloadbalancing:*"
            ],
            "Resource": [
                "arn:aws:elasticloadbalancing:${var.region}:${var.account_number}:listener-rule/net/${var.name}*/*/*/*",
                "arn:aws:elasticloadbalancing:${var.region}:${var.account_number}:listener/app/${var.name}*/*/*",
                "arn:aws:elasticloadbalancing:${var.region}:${var.account_number}:listener/net/${var.name}*/*/*",
                "arn:aws:elasticloadbalancing:${var.region}:${var.account_number}:listener-rule/app/${var.name}*/*/*/*",
                "arn:aws:elasticloadbalancing:${var.region}:${var.account_number}:loadbalancer/app/${var.name}*/*",
                "arn:aws:elasticloadbalancing:${var.region}:${var.account_number}:loadbalancer/net/${var.name}*/*",
                "arn:aws:elasticloadbalancing:${var.region}:${var.account_number}:targetgroup/${var.name}*/*"
            ],
            "Effect": "Allow",
            "Sid": "BoundedByNamespace"
        }
    ]
}
)
}

resource "aws_iam_policy" "ecr_access" {
  name        = "${var.name}-_${var.env}_ecr_access"
  description = "Policy that allows access to ECR"
 
 policy = jsonencode(
 {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:DescribeRepositories"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "UniversalAllow"
        },
        {
            "Action": [
                "ecr:*"
            ],
            "Resource": [
                "arn:aws:ecr:${var.region}:${var.account_number}:repository/${var.name}*"
            ],
            "Effect": "Allow",
            "Sid": "BoundedByNamespace"
        }
    ]
}
)
}
 
resource "aws_iam_policy" "dynamodb_access" {
  name        = "${var.name}-_${var.env}_dynamodb_access"
  description = "Policy that allows access to DynamoDB"
 
 policy = jsonencode(
 {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "dynamodb:List*",
                "dynamodb:Describe*"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "UniversalAllow"
        },
        {
            "Action": [
                "dynamodb:*"
            ],
            "Resource": [
                "arn:aws:dynamodb:${var.region}:${var.account_number}:table/${var.name}*"
            ],
            "Effect": "Allow",
            "Sid": "BoundedByNamespace"
        }
    ]
}
)
}
  
resource "aws_iam_policy" "cloudwatch_access" {
    name = "${var.name}_${var.env}_cloudwatch_access"
    description = "Policy that allows access to Cloudwatch"
    policy = jsonencode(
        {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "autoscaling:Describe*",
                "cloudwatch:Describe*",
                "cloudwatch:Get*",
                "cloudwatch:List*",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:PutRetentionPolicy",
                "logs:Describe*",
                "logs:Get*",
                "logs:List*",
                "logs:*Query*",
                "logs:StartQuery*",
                "logs:StopQuery",
                "logs:TestMetricFilter",
                "logs:FilterLogEvents",
                "events:PutPartnerEvents",
                "events:List*",
                "events:TestEventPattern"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "UniversalAllow"
        },
        {
            "Action": [
                "events:*"
            ],
            "Resource": [
                "arn:aws:events:us-east-1:090785149484:event-bus/${var.name}*",
                "arn:aws:events:us-east-1:090785149484:event-bus/default",
                "arn:aws:events:us-east-1:090785149484:event-source/${var.name}*",
                "arn:aws:events:us-east-1:090785149484:rule/${var.name}*"
            ],
            "Effect": "Allow",
            "Sid": "CloudWatchEvents"
        }
    ]
}
    )
} 

resource "aws_iam_policy" "batchjob_management" {
  name = "${var.name}_${var.env}_batchjob_management_access"
   
  description = "Policy that allows access to batchjob_management"
  
 policy = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": [
                "ecs:ListClusters",
                "ecs:DescribeClusters",
                "ecs:DeleteCluster",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeLaunchConfigurations"
            ],
            "Resource": "*"
        }
    ]
    }
 )
}