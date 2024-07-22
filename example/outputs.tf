
output "sqs_queue_arns" {
  value = { for k, queue in aws_sqs_queue.queues : k => queue.arn }
}

output "sqs_queue_urls" {
  value = { for k, queue in aws_sqs_queue.queues : k => queue.url }
}

output "sqs_queue_names" {
  value = { for k, queue in aws_sqs_queue.queues : k => queue.name }
}
