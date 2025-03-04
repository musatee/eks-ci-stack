module "gateway" {
  source    = "./tf_modules/gateway"
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets["ap-southeast-1a"]
  tags      = local.common_tags
}