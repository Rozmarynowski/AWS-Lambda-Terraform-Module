data "terraform_remote_state" "s3" {
  workspace = terraform.workspace

  backend = "s3"
  config = {
    bucket  = "common-s3-tfstatefiles"
    key     = "s3.tfstate"
    region  = "eu-west-1"
    profile = "common"
  }
}

data "terraform_remote_state" "documentdb" {
  workspace = terraform.workspace
  backend   = "s3"
  config = {
    bucket  = "common-s3-tfstatefiles"
    key     = "documentdb-tester.tfstate"
    region  = "eu-west-1"
    profile = "common"
  }
}

data "terraform_remote_state" "kafka" {
  workspace = terraform.workspace

  backend = "s3"
  config = {
    bucket  = "common-s3-tfstatefiles"
    key     = "kafka.tfstate"
    region  = "eu-west-1"
    profile = "common"
  }

  defaults = {
    kafka_port  = "9094"
    kafka_hosts = ""
    kafka_sg    = ""
  }
}
# Documentdb credentials
data "aws_secretsmanager_secret_version" "documentdb" {
  secret_id = data.terraform_remote_state.documentdb.outputs.documentdb.documentdb.secret_arn
}

# S3 credentials
data "aws_secretsmanager_secret_version" "s3-tester2" {
  secret_id = data.terraform_remote_state.s3.outputs.secret_arns["tester"]
}

