module "lambda_function_existing_package_local" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.4.0"

  function_name = format("%s-%s-%s-lmb-%s-%s",
    var.general.company,
    var.general.environment,
    var.general.account,
    var.lambda_name,
    var.general.suffix
  )
  architectures                  = local.lambda.architectures
  attach_cloudwatch_logs_policy  = local.lambda.attach_cloudwatch_logs_policy
  attach_policy                  = local.lambda.attach_policy
  create_package                 = local.lambda.create_package
  memory_size                    = local.lambda.memory_size
  package_type                   = local.lambda.package_type
  policy                         = var.policy.arn
  publish                        = local.lambda.publish
  runtime                        = local.lambda.runtime
  reserved_concurrent_executions = local.lambda.reserved_concurrent_executions
  timeout                        = local.lambda.timeout


  handler                = var.lambda.handler
  local_existing_package = "./src/${var.lambda.package.artifact}"

}

resource "aws_lambda_event_source_mapping" "sqs" {
  count = contains(keys(var.lambda.events), "sqs") ? 1 : 0

  event_source_arn = var.sqs_event_source_arn

  function_name = module.lambda_function_existing_package_local.lambda_function_arn
  batch_size    = lookup(var.lambda.events.sqs, "batchSize", 6)
}

