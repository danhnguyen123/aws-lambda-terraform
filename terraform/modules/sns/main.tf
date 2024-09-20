resource "aws_sns_topic" "topic" {
  name = var.sns_topic_name
  tags = {
    Managed = "Terraform"
  }
}

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = var.sns_subcription_email
}