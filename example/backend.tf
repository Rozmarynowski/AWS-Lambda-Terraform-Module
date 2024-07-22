terraform {
  backend "s3" {
    bucket         = "common-s3-tfstatefiles"
    key            = "lambdas-module-tests.tfstate"
    dynamodb_table = "common-ddb-tfstatelock"
    region         = "eu-west-1"
    profile        = "common"
  }
}
