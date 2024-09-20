data "aws_s3_bucket" "source" {
  bucket = var.source_bucket_name
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.source.arn
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = data.aws_s3_bucket.source.id

  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.filter_prefix
    filter_suffix       = var.filter_suffix
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}