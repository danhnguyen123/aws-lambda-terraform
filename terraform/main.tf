data "aws_s3_bucket" "source_bucket" {
  bucket = var.source_bucket_name
}

############# Lambda Function ################
module "transform-csv-s3-lambda" {
  source  = "./modules/lambda"
  function_name = var.function_name
  function_role_name = var.function_role_name
  function_bucket_name  = var.function_bucket_name
  layer_name = var.layer_name
  aws_managed_sdk_pandas_layer_arn = var.aws_managed_sdk_pandas_layer_arn
  sns_topic_arn = module.sns-topic-subcription.sns_topic_arn
  env = {
    SERVICE_NAME = var.service_name
    LOG_LEVEL = var.log_level
    SNS_ARN = module.sns-topic-subcription.sns_topic_arn
  }
  depends_on = [ module.sns-topic-subcription ]

}

############# S3 Trigger Lambda ################
module "s3-trigger-lambda" {
  source  = "./modules/s3_notification"
  source_bucket_name = var.source_bucket_name
  lambda_function_arn = module.transform-csv-s3-lambda.lambda_function_arn
  filter_prefix = var.filter_prefix
  filter_suffix = var.filter_suffix
  depends_on = [ module.transform-csv-s3-lambda ]
}

############# SNS ################
module "sns-topic-subcription" {
  source  = "./modules/sns"
  sns_topic_name = var.sns_topic_name
  sns_subcription_email = var.sns_subcription_email
}