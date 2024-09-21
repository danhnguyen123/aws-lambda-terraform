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

variable "package_s3_key" {
    type = string
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