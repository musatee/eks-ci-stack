module "vpc" {
  source            = "./tf_modules/vpc"
  cidr_block        = local.vpc_cidr
  subnet_cidr_block = local.subnet_cidr_block
  tags              = local.common_tags
}