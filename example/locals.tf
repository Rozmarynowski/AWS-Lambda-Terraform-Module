locals {
  # Load defaults and workspace variables
  general = merge(
    yamldecode(file(".defaults/general.yaml")),
    yamldecode(file("${terraform.workspace}/general.yaml")),
  )
  lambda = merge(
    yamldecode(file(".defaults/lambda.yaml")),
    yamldecode(file("${terraform.workspace}/lambda.yaml"))
  )
  sqs_queues = {
    tester1   = format("%s-%s-%s-sqs-%s-tester1-%s.fifo", local.general.company, local.general.environment, local.general.account, local.general.application, local.general.suffix),
    tester2   = format("%s-%s-%s-sqs-%s-tester2-%s.fifo", local.general.company, local.general.environment, local.general.account, local.general.application, local.general.suffix)
  }
  buckets = {
    tester = {
      bucket_name       = jsondecode(data.aws_secretsmanager_secret_version.s3-tester.secret_string)["bucket_name"]
      access_key_id     = jsondecode(data.aws_secretsmanager_secret_version.s3-tester.secret_string)["access_key_id"]
      access_key_secret = jsondecode(data.aws_secretsmanager_secret_version.s3-tester.secret_string)["access_key_secret"]
      arn               = data.terraform_remote_state.s3.outputs.secret_arns["tester"]
    }
  }


  documentdb = {
    user        = jsondecode(data.aws_secretsmanager_secret_version.documentdb.secret_string)["db_user"]
    password    = jsondecode(data.aws_secretsmanager_secret_version.documentdb.secret_string)["db_password"]
    host        = data.terraform_remote_state.documentdb.outputs.documentdb.documentdb.host
    host_reader = data.terraform_remote_state.documentdb.outputs.documentdb.documentdb.host_reader
    port        = jsondecode(data.aws_secretsmanager_secret_version.documentdb.secret_string)["db_port"]
    name        = data.terraform_remote_state.documentdb.outputs.documentdb.documentdb.name
  }
  kafka = {
    hosts = data.terraform_remote_state.kafka.outputs.kafka_hosts
    port  = data.terraform_remote_state.kafka.outputs.kafka_port
    arn  = data.terraform_remote_state.kafka.outputs.kafka_arn
  }
  
  dynamic_envs = {
    tester-1 = {
      MONGO_URL = "mongodb://${local.documentdb.user}:${local.documentdb.password}@${local.documentdb.host}:${local.documentdb.port}/?ssl=true&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false"
    }
    tester-2 = {
      SQS_QUEUE = local.buckets["tester1"].url
    }
  }



}
