module "route_table" {
  source = "./tf_modules/route_table"
  routes = local.route
  vpc_id = module.vpc.vpc_id
  igw_id = module.gateway.igw_id
  nat_id = module.gateway.nat_id
  tags   = local.common_tags
}

resource "aws_route_table_association" "public_rt_association" {
  for_each       = module.vpc.public_subnets
  subnet_id      = each.value
  route_table_id = module.route_table.public_rt_id
}

resource "aws_route_table_association" "private_rt_association" {
  for_each       = module.vpc.private_subnets
  subnet_id      = each.value
  route_table_id = module.route_table.private_rt_id
}