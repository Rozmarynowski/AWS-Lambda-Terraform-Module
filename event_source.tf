# Managed Streaming for Apache Kafka (MSK) trigger
resource "aws_lambda_event_source_mapping" "kafka_lambda_trigger" {
  count = contains(keys(var.lambda.events), "msk") ? 1 : 0

  event_source_arn  = var.kafka_event_source_arn
  function_name     = module.lambda_function_existing_package_local.lambda_function_arn
  topics            = [local.lambda.kafka_topic]
  starting_position = local.lambda.kafka_starting_position
  batch_size        = local.lambda.kafka_batch_size
  enabled           = local.lambda.kafka_enabled
}


# Simple Queue Service trigger
resource "aws_lambda_event_source_mapping" "sqs-lambda-trigger" {
  count = contains(keys(var.lambda.events), "sqs") ? 1 : 0

  event_source_arn = var.sqs_event_source_arn

  function_name = module.lambda_function_existing_package_local.lambda_function_arn
  batch_size    = local.lambda.sqs_batch_size
}


# S3 Bucket Trigger
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
