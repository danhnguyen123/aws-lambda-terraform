variable "source_bucket_name" {
    type = string
}

variable "lambda_function_arn" {
    type = string
}

variable "filter_prefix" {
    type = string
    default = ""
}

variable "filter_suffix" {
    type = string
    default = ""
}