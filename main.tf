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

  environment_variables = var.lambda.environment

  vpc_subnet_ids         = local.lambda.vpc ? local.lambda.vpc_subnet_ids : null
  vpc_security_group_ids = local.lambda.vpc ? local.lambda.vpc_security_group_ids : null

}


