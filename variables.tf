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

variable "policy" {
  type = object({
    arn = string
  })
  description = "Lambda IAM Policy"
}


