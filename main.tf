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

resource "aws_lambda_event_source_mapping" "sqs-lambda-trigger" {
  count = contains(keys(var.lambda.events), "sqs") ? 1 : 0

  event_source_arn = var.sqs_event_source_arn

  function_name = module.lambda_function_existing_package_local.lambda_function_arn
  batch_size    = lookup(var.lambda.events.sqs, "batchSize", 6)
}

resource "aws_lambda_permission" "allow_bucket" {
  count = contains(keys(var.lambda.events), "s3") ? 1 : 0

  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function_existing_package_local.lambda_function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_event_source.bucket_arn

  depends_on = [module.lambda_function_existing_package_local]
}

resource "aws_s3_bucket_notification" "s3-lambda-trigger" {
  count = contains(keys(var.lambda.events), "s3") ? 1 : 0

  bucket = var.s3_event_source.bucket_name
  lambda_function {
    lambda_function_arn = module.lambda_function_existing_package_local.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.allow_bucket]

}
