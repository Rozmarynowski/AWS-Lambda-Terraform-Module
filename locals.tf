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

  }

}
