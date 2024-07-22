resource "aws_sqs_queue" "queues" {
  for_each = local.sqs_queues

  name = each.value

  fifo_queue                  = true
  content_based_deduplication = false
  message_retention_seconds   = 604800
  visibility_timeout_seconds  = 600
}
