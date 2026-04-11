# variable "key_name" {
#   description = "EC2 Key Pair"
#   type = string
# }

# variable "region" {
#   description = "AWS region"
#   type        = string
#   default     = "us-east-1"
# }

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}