module "eks-cluster" {
  source                    = "./tf_modules/eks"
  env                       = local.env
  project                   = local.project
  subnet_ids                = [for az, subnet_id in module.vpc.private_subnets : subnet_id]
  tags                      = local.common_tags
  eks_version               = local.eks_version
  vpc_id                    = module.vpc.vpc_id
  vpc_cidr_block            = local.vpc_cidr
  worker_node_role_arn      = module.eks-iam.aws_iam_role_arn
  ondemand_desired_size     = local.eks_ondemand_desired_size
  ondemand_max_size         = local.eks_ondemand_max_size
  ondemand_min_size         = local.eks_ondemand_min_size
  spot_desired_size         = local.eks_spot_desired_size
  spot_max_size             = local.eks_spot_max_size
  spot_min_size             = local.eks_spot_min_size
  node_group_instance_types = local.node_group_instance_types
}

# EKS IRSA 
module "iam_iam-role-for-service-accounts-eks" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version   = "5.39.1"
  role_name = "${local.env}_${local.project}_karpenter_controller_EKS"
  role_policy_arns = {
    policy = aws_iam_policy.karpenter_controller_policy.arn
  }
  attach_karpenter_controller_policy = true

  karpenter_controller_cluster_name       = module.eks-cluster.cluster_name
  karpenter_controller_node_iam_role_arns = [module.eks-iam.aws_iam_role_arn]

  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks-cluster.openID_connect_arn
      namespace_service_accounts = ["kube-system:karpenter"]
    }
  }
}

module "irsa_alb_controller" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version   = "5.39.1"
  role_name = "${local.env}_${local.project}_AmazonEKSLoadBalancerControllerRole"
  role_policy_arns = {
    policy = aws_iam_policy.alb_ingress_controller_policy.arn
  }

  oidc_providers = {
    one = {
      provider_arn               = module.eks-cluster.openID_connect_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}