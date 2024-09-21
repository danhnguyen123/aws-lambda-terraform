variable "region" {
    type = string
    default = "us-east-1"
}

variable "function_name" {
    type = string
}

variable "function_bucket_name" {
    type = string
}

variable "function_role_name" {
    type = string
}

variable "image_uri" {
    type = string
}

variable "service_name" {
    type = string
}

variable "log_level" {
    type = string
}

variable "source_bucket_name" {
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

variable "sns_topic_name" {
    type = string
}

variable "sns_subcription_email" {
    type = string
}
