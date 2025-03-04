# create public RT
resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.routes["public"]
    content {
      cidr_block = route.key
      gateway_id = route.value == "igw" ? var.igw_id : route.value
    }
  }
  tags = merge(tomap({ "Name" = join("-", [var.tags["Environment"], var.tags["Project"], "public-RT"]) }), var.tags, tomap({ "ResourceType" = "Public RT" }))

}

# create private RT
resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.routes["private"]
    content {
      cidr_block = route.key
      gateway_id = route.value == "nat" ? var.nat_id : route.value
    }
  }
  tags = merge(tomap({ "Name" = join("-", [var.tags["Environment"], var.tags["Project"], "private-RT"]) }), var.tags, tomap({ "ResourceType" = "Private RT" }))

}