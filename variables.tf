variable "general" {
  description = "General settings"
  type = object({
    company     = string
    environment = string
    account     = string
    application = string
    suffix      = string
  })
}
variable "lambda_name" {
  type        = string
  description = "Base name of Lambda Function"
}

variable "lambda" {
  type        = any
  description = "Lambda settings"
  default     = {}
}

variable "dynamic_envs" {
  type        = any
  description = "Additional dynamic variabbles for other AWS resources"
  default     = {}
}

variable "sqs_event_source_arn" {
  type        = string
  description = "ARN to SQS that triggers lambda"
  default     = null
}

variable "s3_event_source" {
  type = object({
    bucket_arn  = string
    bucket_name = string
  })
  description = "The name and arn of the S3 bucket that triggers lambda"
}

variable "kafka_event_source_arn" {
  type        = string
  description = "ARN to Kafka (MSK) that triggers lambda"
  default     = null
}

variable "policy" {
  type = object({
    arn = string
  })
  description = "Lambda IAM Policy"
}


