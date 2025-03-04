variable "routes" {
  type = map(map(string))
}

variable "vpc_id" {
  type = string
}

variable "igw_id" {
  type = string
}

variable "nat_id" {
  type = string
}

variable "tags" {
  type = map(string)
}