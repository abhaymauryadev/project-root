variable "key_name" {
  description = "EC2 Key Pair"
  type = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}