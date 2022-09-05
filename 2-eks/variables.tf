variable "region" {
  type        = string
  default     = "us-east-1"
  description = "region"
}

variable "project" {
  type        = string
  default     = "proj-jmy-demo"
  description = "project"
}

variable "name_of_s3_bucket" {
  type        = string
  default     = "terraform-state-bucket-jmy"
  description = "name_of_s3_bucket"
}

variable "generic_tags" {
  type = map(any)
  default = {
    Creator     = "terraform"
    Environment = "dev"
    User        = "Jimmy Cui"
  }
  description = "generic_tags"
}
