module "ecr-admin" {
  source = "./tf_modules/ecr"
  name   = "${local.env}-${local.project}-admin"
  tags   = merge(tomap({"Name" = join("-", [local.env, local.project, "admin"])}), tomap({"ResourceType" = "ecr"}), local.common_tags)
}

module "ecr-product" {
  source = "./tf_modules/ecr"
  name   = "${local.env}-${local.project}-product"
  tags   = merge(tomap({"Name" = join("-", [local.env, local.project, "product"])}), tomap({"ResourceType" = "ecr"}), local.common_tags)
}