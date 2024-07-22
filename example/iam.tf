resource "aws_iam_policy" "lambda_policy" {
  name = format("%s-%s-%s-pol-lmb-%s-%s",
    local.general.company,
    local.general.environment,
    local.general.account,
    local.general.application,
  )

  description = "IAM policy for products lambda offline receipts"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
       {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        Effect   = "Allow",
        Resource = [for name, bucket in local.buckets : "arn:aws:s3:::${bucket.bucket_name}/*"]
      },
      {
        Effect   = "Allow"
        Action   = [
          "kafka:DescribeClusterV2",
          "kafka:DescribeCluster",
          "kafka:GetBootstrapBrokers",
          "kafka:ListTopics"
        ]
        Resource = "${local.kafka.arn}"
      },
      {
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeVpcs",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups"
        ],
        Effect   = "Allow",
        Resource = ["*"]
      },
      {
        Effect = "Allow",
        Action = [
          "sqs:*"
        ],
        Resource = "arn:aws:sqs:eu-central-1:*:*"
      },
      {
        Action = [
          "ssm:GetParametersByPath"
        ],
        Effect = "Allow",
        Resource = [
          "arn:aws:ssm:*:*:parameter/${local.general.application}"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter"
        ]
        Resource = [
          "arn:aws:ssm:*:*:parameter/${local.general.application}/*"
        ]
      }

    ]
  })
}

