variable "cidr_block" {
  description = "cidr block of vpc"
  type        = string
}

variable "subnet_cidr_block" {
  description = "subnet cidr block"
  type        = map(map(string))
}

variable "tags" {
  description = "resource tag"
  type        = map(string)
}
