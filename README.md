# AWS-Lambda-Terraform-Module

This Terraform  module allows for the creation of AWS Lambdas configured in a manner analogous to the Serverless framework.

## Configuration

Lambda functions should be defined in a YAML file as follows:

```yaml
functions:
  lambda-tester-1:
    handler: Tester1.Function::FunctionHandler
    memorySize: 1024
    reservedConcurrency: 3
    timeout: 600
    vpc: false
    package:
      artifact: Tester1/Tester1.zip
    events:
      sqs:
        queue_name: tester1
        batchSize: 1
    environment:
      environment: stg
     
  lambda-tester-2:
    handler: Tester2.Function::FunctionHandler
    memorySize: 1024
    reservedConcurrency: 3
    timeout: 600
    vpc: false
    package:
      artifact: Tester2/Tester2.zip
    events:
      s3:
        bucket_name: test-bucket
        batchSize: 1
    environment:
      environment: stg
      region: eu-central-1
