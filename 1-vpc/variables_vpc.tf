variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "vpc_cidr"
}

variable "private_subnets" {
  type        = list(any)
  default     = []
  description = "private_subnets"
}

variable "public_subnets" {
  type        = list(any)
  default     = []
  description = "public_subnets"
}

variable "azs" {
  type        = list(any)
  default     = []
  description = "azs"
}