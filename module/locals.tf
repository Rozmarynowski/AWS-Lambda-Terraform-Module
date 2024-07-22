locals {
  # Lambda default settings
  lambda = {                                                                                   ## Default values ##
    architectures                  = lookup(var.lambda, "architectures", [])                   # []
    attach_cloudwatch_logs_policy  = lookup(var.lambda, "attach_cloudwatch_logs_policy", true) # true
    attach_policy                  = lookup(var.lambda, "attach_policy", true)                 # true
    create_package                 = lookup(var.lambda, "create_package", false)               # false
    memory_size                    = lookup(var.lambda, "memory_size", 1024)                   # 1024
    package_type                   = lookup(var.lambda, "package_type", "Zip")                 # Zip
    publish                        = lookup(var.lambda, "publish", true)                       # true
    reserved_concurrent_executions = lookup(var.lambda, "reservedConcurrency", -1)             # -1
    runtime                        = lookup(var.lambda, "runetime", "dotnet6")                 # dotnet6
    timeout                        = lookup(var.lambda, "timeout", 6)                          # 6
    vpc                            = lookup(var.lambda, "vpc", false)                          # false
    vpc_subnet_ids                 = lookup(var.lambda, "vpc_subnet_ids", [])                  # []
    vpc_security_group_ids         = lookup(var.lambda, "vpc_security_group_ids", [])          # false

    # Check if 'msk' exists in 'var.lambda.events' and set the values accordingly
    kafka_enabled           = contains(keys(var.lambda.events), "msk") ? lookup(var.lambda.events.msk, "enabled", true) : true                               # true
    kafka_batch_size        = contains(keys(var.lambda.events), "msk") ? lookup(var.lambda.events.msk, "batchSize", "1") : "1"                               # 1
    kafka_topic             = contains(keys(var.lambda.events), "msk") ? lookup(var.lambda.events.msk, "topic", "") : ""                                     #""
    kafka_starting_position = contains(keys(var.lambda.events), "msk") ? lookup(var.lambda.events.msk, "starting_position", "TRIM_HORIZON") : "TRIM_HORIZON" #"TRIM_HORIZON"

    # Check if 'sqs' exists in 'var.lambda.events' and set the values accordingly
    sqs_batch_size = contains(keys(var.lambda.events), "sqs") ? lookup(var.lambda.events.sqs, "batchSize", 6) : 6 # 6

  }
}
