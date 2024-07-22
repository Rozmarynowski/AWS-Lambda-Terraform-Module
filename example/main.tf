module "lambda" {
  source = "../module"
  for_each = local.lambda.functions

  # General settings
  general = local.general

  lambda_name = each.key
  # Lambda settings
  lambda = each.value

  # Dynamic envs
  dynamic_envs =  try(local.dynamic_envs[each.key], null)  

  # sqs trigger
  sqs_event_source_arn = try(aws_sqs_queue.queues[each.value.events.sqs.queue_name].arn, null)
  # s3 trigger
  s3_event_source = {
    bucket_name = try(local.buckets[each.value.events.s3.bucket_name].bucket_name, null)
    bucket_arn  = try(local.buckets[each.value.events.s3.bucket_name].arn, null)
  }

  # msk trigger
  kafka_event_source_arn = local.kafka.arn

  #iam policy
  policy = {
    arn = aws_iam_policy.lambda_policy.arn
  }

}
