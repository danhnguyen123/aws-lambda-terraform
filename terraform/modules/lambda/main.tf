
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
  image_uri     = var.image_uri
  package_type  = "Image"
  memory_size = var.memory_size
  timeout = var.timeout

  environment {
    variables = var.env
  }

  tags = {
    Managed = "Terraform"
  }
}