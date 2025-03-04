module "karpenter_sqs_queue" {
  source = "./tf_modules/sqs-karpenter"
  name   = "${local.env}-${local.project}-karpenter-sqs-queue"
  tags   = local.common_tags
}