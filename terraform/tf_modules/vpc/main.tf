resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags                 = merge(tomap({ "Name" = join("-", [var.tags["Environment"], var.tags["Project"], "vpc"]) }), var.tags, tomap({ "ResourceType" = "VPC" }))
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  for_each          = var.subnet_cidr_block["public"]
  cidr_block        = each.value
  availability_zone = each.key

  tags = merge(tomap({ "Name" = join("-", [var.tags["Environment"], var.tags["Project"], "public-subnet-${each.key}"]) }), var.tags, tomap({ "ResourceType" = "subnet" }))
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  for_each          = var.subnet_cidr_block["private"]
  cidr_block        = each.value
  availability_zone = each.key

  tags = merge(tomap({ "Name" = join("-", [var.tags["Environment"], var.tags["Project"], "private-subnet-${each.key}"]) }), var.tags, tomap({ "ResourceType" = "subnet" }))
}