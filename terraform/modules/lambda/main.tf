locals {
    timestamp = formatdate("YYMMDDhhmmss", timestamp())  # this is kind of annoying but makes function deploy every time
}

# Bucket to store source code "

resource "aws_s3_bucket" "bucket" {
  bucket = var.function_bucket_name

  tags = {
    Managed = "Terraform"
  }
}

# Zip source code and upload to s3 bucket #

data "archive_file" "source" {
    type = "zip"
    excludes    = split("\n", file("${path.root}/../src/.funcignore"))
    source_dir = "${path.root}/../src" # Directory where your Python source code is
    output_path = "${path.root}/src-${var.function_name}-${local.timestamp}.zip"
}

resource "aws_s3_object" "src_zip" {
  bucket = aws_s3_bucket.bucket.id
  key    = "src/src-${var.function_name}-${local.timestamp}.zip"
  source = data.archive_file.source.output_path
  depends_on = [ aws_s3_bucket.bucket ]
}

# Upload library zip to s3 bucket and create layer #

resource "aws_s3_object" "layer_zip" {
  bucket = aws_s3_bucket.bucket.id
  key    = "layer/layer-${var.function_name}-${local.timestamp}.zip"
  source = "${path.root}/../layer.zip"
  depends_on = [ aws_s3_bucket.bucket ]
}

resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name = var.layer_name
  compatible_architectures = ["x86_64"]
  compatible_runtimes = ["python3.11"]
  s3_bucket = aws_s3_bucket.bucket.id
  s3_key = aws_s3_object.layer_zip.key
  # source_code_hash = aws_s3_object.layer_zip.checksum_sha256
  depends_on = [ aws_s3_object.layer_zip ]
}

# Create role for lambda #
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = var.function_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags = {
    Managed = "Terraform"
  }
}

# Attach AWSLambdaBasicExecutionRole policy to Lambda role
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create lambda #

resource "aws_lambda_function" "lambda_function" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_role.arn
  s3_bucket = aws_s3_bucket.bucket.id
  s3_key = aws_s3_object.src_zip.key
  handler       = "main.main"

  layers = [ aws_lambda_layer_version.lambda_layer.arn ]

  runtime = var.runtime
  memory_size = var.memory_size
  timeout = var.timeout

  environment {
    variables = var.env
  }

  # source_code_hash = aws_s3_object.src_zip.checksum_sha256

  tags = {
    Managed = "Terraform"
  }
}