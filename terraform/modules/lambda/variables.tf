variable "function_name" {
    type = string
}

variable "function_role_name" {
    type = string
}

variable "function_bucket_name" {
    type = string
}

variable "layer_name" {
    type = string
}

variable "runtime" {
    type = string
    default = "python3.11"
}

variable "memory_size" {
    type = number
    default = 128
}

variable "timeout" {
    type = number
    default = 600
}

variable "env" {
    type = map(string)
    description = "(Optional) Environment variables."
    default = {}
}

variable "aws_managed_sdk_pandas_layer_arn" {
    type = string
}

variable "sns_topic_arn" {
    type = string
}

variable "s3_source_bucket_arn" {
    type = string
}