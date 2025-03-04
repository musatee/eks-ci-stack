# create IGW 
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags   = merge(tomap({ "Name" = join("-", [var.tags["Environment"], var.tags["Project"], "igw"]) }), var.tags, tomap({ "ResourceType" = "IGW" }))
}

# create EIP
resource "aws_eip" "eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
  tags       = merge(tomap({ "Name" = join("-", [var.tags["Environment"], var.tags["Project"], "eip"]) }), var.tags, tomap({ "ResourceType" = "EIP" }))
}

# create NAT gateway 
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = var.subnet_id
  tags          = merge(tomap({ "Name" = join("-", [var.tags["Environment"], var.tags["Project"], "nat"]) }), var.tags, tomap({ "ResourceType" = "NAT" }))

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

